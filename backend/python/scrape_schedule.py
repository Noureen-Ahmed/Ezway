#!/usr/bin/env python3
"""
Schedule PDF Scraper for Faculty of Science - Ain Shams University
Extracts course schedule data from PDF and outputs structured JSON.

Usage:
    python scrape_schedule.py <pdf_path> [--output <json_path>]
    python scrape_schedule.py <pdf_path> --semester "Spring" --academic-year "2025/2026"
"""

import sys, json, re, argparse, pdfplumber
from pathlib import Path

# pdfplumber reads RTL Arabic text in visual order (characters appear reversed).
# e.g. "السبت" (Saturday) arrives as "تبسلا" — we map the visual-order strings.
DAY_MAP = {
    "تبسلا":    "SATURDAY",
    "دحلأا":    "SUNDAY",
    "دــحلأا":  "SUNDAY",
    "نينثلإا":  "MONDAY",
    "يننثلإا":  "MONDAY",
    "ءاثلاثلا": "TUESDAY",
    "ءاعبرلأا": "WEDNESDAY",
    "سيمخلا":   "THURSDAY",
    "ةعمجلا":   "FRIDAY",
}

PROGRAM_MAP = {
    "تاــــــــيضايرلا جمانرب":                  "Mathematics",
    "تايضايرلا جمانرب":                          "Mathematics",
    "بساحلا مولعو ةتحبلا تايضايرلا جمانرب":    "Pure Mathematics and Computer Science",
    "بساحلا مولعو ىضايرلا ءاصحلإا جمانرب":     "Mathematical Statistics and Computer Science",
    "بساحلا مولع جمانرب":                       "Computer Science",
    "ءايزيفلا جمانرب":                          "Physics",
    "ةيويحلا ءايزيفلا جمانرب":                 "Biophysics",
    "ءايميكلاو ءايزيفلا جمانرب":               "Physics and Chemistry",
    "بساحلا مولعو ءايزيفلا جمانرب":            "Physics and Computer Science",
    "ءايميكلا جمانرب":                          "Chemistry",
    "ةيقيبطتلا ءايميكلا جمانرب":               "Applied Chemistry",
    "تاـــــبنلا جمانرب":                       "Botany",
    "تابنلا جمانرب":                            "Botany",
    "ءايميكلاو تابنلا جمانرب":                 "Botany and Chemistry",
    "ناويحلا ملع جمانرب":                       "Zoology",
    "ءايميكلاو ناويحلا جمانرب":                "Zoology and Chemistry",
    "ءايميك/ تارشح جمانرب":                    "Entomology and Chemistry",
    "ءايميكلاو ةيويحلا ءايميكلا جمانرب":       "Biochemistry and Chemistry",
    "ةيويحلا ءايميكلا جمانرب":                 "Biochemistry",
    "ىجولويبوركيملا جمانرب":                   "Microbiology",
    "ءايميكلاو ىجولويبوركيملا جمانرب":         "Microbiology and Chemistry",
    "ايجولويجلا":                               "Geology",
    "ءايميكلاو ايجولويجلا":                    "Geology and Chemistry",
    "ءايزيفويجلا و ايجولويجلا":               "Geology and Geophysics",
    "ءاــــــــــــــــــــــــــــــــيزيفويجلا": "Geophysics",
    "ءايزيفويجلا":                             "Geophysics",
}

LESSON_TYPE_MAP = {
    "ةرضاحم":   "LECTURE",
    "خ ةرضاحم": "LECTURE",
    "نيرامت":   "TUTORIAL",
    "لمعم":     "LAB",
    "ىلمع":     "LAB",
    "ثحب":      "RESEARCH",
}

LOCATION_MAP = {
    "مسقلا": "Department",
    "القسم": "Department",
}

def normalize_time(raw):
    """Convert Arabic schedule time like '11-8', '5-2' to 24h (HH:MM, HH:MM)."""
    if not raw: return None, None
    cleaned = raw.strip().replace(" ", "").replace("–","-").replace("−","-")
    parts = cleaned.split("-")
    if len(parts) != 2: return None, None
    try:
        a, b = int(parts[0]), int(parts[1])
        def to24(h):
            return h + 12 if 1 <= h <= 6 else h
        ta, tb = to24(a), to24(b)
        s, e = min(ta, tb), max(ta, tb)
        if s < 7 or e > 18: return None, None
        return f"{s:02d}:00", f"{e:02d}:00"
    except ValueError:
        return None, None

def normalize_code(raw):
    if not raw or raw.strip() in ("--","-","","None"): return None
    cleaned = re.sub(r"\s+","",raw.strip().upper())
    if re.match(r"^[A-Z]{2,6}\d{3,4}[A-Z]?$", cleaned): return cleaned
    return None

def is_header_row(row):
    if not row: return False
    joined = " ".join(str(c) for c in row if c)
    return any(h in joined for h in ["موـــيلا","مويلا","تاعاسلا","تــــقولا"])

def get_program_name(page):
    text = page.extract_text()
    if not text: return None
    lines = [l.strip() for l in text.split("\n") if l.strip()]
    if len(lines) < 4: return None
    candidate = lines[3]
    if candidate in PROGRAM_MAP: return PROGRAM_MAP[candidate]
    for k, v in PROGRAM_MAP.items():
        if k in candidate or candidate in k: return v
    return candidate

def translate_location(raw):
    if not raw: return None
    s = raw.strip()
    return LOCATION_MAP.get(s, s) or None

def extract_page_schedules(page, program_name, semester, academic_year):
    tables = page.extract_tables()
    if not tables: return []
    entries = []
    current_day = None

    for table in tables:
        for row in table:
            if is_header_row(row): continue
            if len(row) < 6: continue

            location    = translate_location(row[0])
            course_name = (row[1] or "").strip() or None
            time_raw    = (row[2] or "").strip()
            credits_raw = (row[3] or "").strip()
            code_raw    = (row[4] or "").strip()
            lesson_raw  = (row[5] or "").strip()
            day_raw     = (row[6] or "").strip() if len(row) > 6 else ""

            parsed_day = DAY_MAP.get(day_raw.strip())
            if parsed_day:
                current_day = parsed_day

            if not course_name and not normalize_code(code_raw): continue

            code = normalize_code(code_raw)
            start_time, end_time = normalize_time(time_raw)
            lesson_type = LESSON_TYPE_MAP.get(lesson_raw, "LECTURE")
            is_elective = "خ" in (lesson_raw or "")

            try:
                credit_hours = int(credits_raw) if credits_raw and credits_raw.isdigit() else None
            except:
                credit_hours = None

            if course_name:
                course_name = " ".join(course_name.split())

            entries.append({
                "courseCode":   code,
                "courseName":   course_name,
                "dayOfWeek":    current_day,
                "startTime":    start_time,
                "endTime":      end_time,
                "location":     location,
                "lessonType":   lesson_type,
                "isElective":   is_elective,
                "creditHours":  credit_hours,
                "program":      program_name,
                "semester":     semester,
                "academicYear": academic_year,
            })
    return entries

def scrape_pdf(pdf_path, semester="Spring", academic_year="2025/2026"):
    all_entries = []
    programs_found = []

    with pdfplumber.open(pdf_path) as pdf:
        for page_num, page in enumerate(pdf.pages[1:], start=2):
            program_name = get_program_name(page)
            if program_name and program_name not in programs_found:
                programs_found.append(program_name)
            page_entries = extract_page_schedules(
                page, program_name or f"Unknown (page {page_num})", semester, academic_year
            )
            all_entries.extend(page_entries)

    seen = set()
    unique = []
    for e in all_entries:
        key = (e["courseCode"], e["dayOfWeek"], e["startTime"], e["program"], e["lessonType"])
        if key not in seen:
            seen.add(key)
            unique.append(e)

    return {
        "success": True,
        "totalEntries": len(unique),
        "programs": programs_found,
        "schedules": unique,
    }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("pdf_path")
    parser.add_argument("--output", "-o")
    parser.add_argument("--semester", default="Spring")
    parser.add_argument("--academic-year", default="2025/2026")
    args = parser.parse_args()

    if not Path(args.pdf_path).exists():
        print(json.dumps({"success": False, "error": f"File not found: {args.pdf_path}"}))
        sys.exit(1)

    try:
        result = scrape_pdf(args.pdf_path, args.semester, args.academic_year)
        output_str = json.dumps(result, ensure_ascii=False, indent=2)
        if args.output:
            Path(args.output).write_text(output_str, encoding="utf-8")
            sys.stderr.write(f"✅ {result['totalEntries']} entries, {len(result['programs'])} programs → {args.output}\n")
        else:
            print(output_str)
    except Exception as exc:
        import traceback
        print(json.dumps({"success": False, "error": str(exc), "trace": traceback.format_exc()}, ensure_ascii=False))
        sys.exit(1)

if __name__ == "__main__":
    main()
