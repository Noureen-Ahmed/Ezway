#!/usr/bin/env python3
"""
Schedule PDF Scraper for Faculty of Science - Ain Shams University
Extracts course schedule data from PDF and outputs structured JSON.

Usage:
    python scrape_schedule.py <pdf_path> [--output <json_path>]
    python scrape_schedule.py <pdf_path> --semester "Spring" --academic-year "2025/2026"

pdfplumber reads RTL Arabic text in visual order (characters reversed).
Column order in pdfplumber output is not reliable for RTL tables, so we
classify each cell by its *content* rather than its index position.
"""

import sys, json, re, argparse, pdfplumber
from pathlib import Path

# ─── Day map (reversed visual-order strings) ─────────────────────────────────
DAY_MAP = {
    "تبسلا":     "SATURDAY",
    "دحلأا":     "SUNDAY",
    "دحلاا":     "SUNDAY",
    "دــحلأا":   "SUNDAY",
    "دـحلأا":    "SUNDAY",
    "نينثلإا":   "MONDAY",
    "يننثلإا":   "MONDAY",
    "نينثلاا":   "MONDAY",
    "نينثلإا":   "MONDAY",
    "ءاثلاثلا":  "TUESDAY",
    "ءثالاثلا":  "TUESDAY",   # alternate hamza/char form
    "ءاعبرلأا":  "WEDNESDAY",
    "ءاعبرلاا":  "WEDNESDAY",
    "سيمخلا":    "THURSDAY",
    "سيملخا":    "THURSDAY",  # alternate char order
    "ةعمجلا":    "FRIDAY",
}

# ─── Program map (reversed visual-order Arabic) ───────────────────────────────
PROGRAM_MAP = {
    "تاــــيضايرلا جمانرب":                   "Mathematics",
    "تايضايرلا جمانرب":                        "Mathematics",
    "بساحلا مولعو ةتحبلا تايضايرلا جمانرب":   "Pure Mathematics and Computer Science",
    "بساحلا مولعو ىضايرلا ءاصحلإا جمانرب":    "Mathematical Statistics and Computer Science",
    "يضايرلا ءاصحلإا جمانرب":                  "Mathematical Statistics and Computer Science",
    "بساحلا مولع جمانرب":                      "Computer Science",
    "ءايزيفلا جمانرب":                         "Physics",
    "ةيويحلا ءايزيفلا جمانرب":                "Biophysics",
    "ءايميكلاو ءايزيفلا جمانرب":              "Physics and Chemistry",
    "بساحلا مولعو ءايزيفلا جمانرب":           "Physics and Computer Science",
    "ءايميكلا جمانرب":                         "Chemistry",
    "ةيقيبطتلا ءايميكلا جمانرب":              "Applied Chemistry",
    "تابنلا جمانرب":                           "Botany",
    "ءايميكلاو تابنلا جمانرب":                "Botany and Chemistry",
    "ناويحلا ملع جمانرب":                      "Zoology",
    "ءايميكلاو ناويحلا جمانرب":               "Zoology and Chemistry",
    "ءايميك/ تارشح جمانرب":                   "Entomology and Chemistry",
    "ءايميكلاو ةيويحلا ءايميكلا جمانرب":      "Biochemistry and Chemistry",
    "ةيويحلا ءايميكلا جمانرب":                "Biochemistry",
    "ىجولويبوركيملا جمانرب":                  "Microbiology",
    "ءايميكلاو ىجولويبوركيملا جمانرب":        "Microbiology and Chemistry",
    "ايجولويجلا جمانرب":                       "Geology",
    "ءايميك ايجولويجلا جمانرب":               "Geology and Chemistry",
    "ءايزيفويجلاو ايجولويجلا جمانرب":         "Geology and Geophysics",
    "ءايزيفويجلا جمانرب":                      "Geophysics",
    "يجولويبلا جمانرب":                        "Biology",
}

# ─── Lesson type map (reversed visual-order Arabic) ──────────────────────────
LESSON_TYPE_MAP = {
    "ةرضاحم":    "LECTURE",
    "ةرضامح":    "LECTURE",
    "خ ةرضاحم":  "LECTURE",
    "خ ةرضامح":  "LECTURE",
    "نيرامت":    "TUTORIAL",
    "نيراتم":    "TUTORIAL",
    "لمعم":      "LAB",
    "ىلمع":      "LAB",
    "يلمع":      "LAB",
    "ىملع":      "LAB",       # alternate char order
    "ثحب":       "RESEARCH",
}

# ─── Location map (reversed visual-order Arabic) ──────────────────────────────
LOCATION_MAP = {
    "مسقلا":        "Department",
    "مسفلا":        "Department",  # alternate PDF rendering of مسقلا
    "القسم":        "Department",
    "مسقب":         "Department",  # بالقسم (at the department)
    "دامح جردم":    "Hammad Hall",  # حماد مدرج in pdfplumber visual order
    "داماح جردم":   "Hammad Hall",  # alternate PDF encoding variant
    "داحم جردم":    "Hammad Hall",  # alternate PDF encoding variant
    "للاه جردم":    "Hilal Hall",
    "للاه":         "Hilal Hall",
    "حون جردم":     "Noah Hall",
    "حون":          "Noah Hall",
    "يزاجح جردم":   "Hegazy Hall",
    "ىزاجح جردم":   "Hegazy Hall",  # ى variant
    "جردم يزاجح":   "Hegazy Hall",  # words reversed across line break
    "جردم ىزاجح":   "Hegazy Hall",  # ى + reversed
    "يزاجح":        "Hegazy Hall",  # partial
    "ىزاجح":        "Hegazy Hall",
    ")ب( ةعاق":     "Classroom B",
    "ب( ةـــعاق":   "Classroom B",
    "ب ةعاق":       "Classroom B",
    "ب ةـعاق":      "Classroom B",
    "ب ةـــعاق":    "Classroom B",
    "ب هعاق":       "Classroom B",  # ه variant of ة
    ")أ( ةعاق":     "Classroom A",
    "أ ةعاق":       "Classroom A",
    "أ هعاق":       "Classroom A",
    ")ج( ةعاق":     "Classroom C",
    "ج ةعاق":       "Classroom C",
    "دامح جر دم":   "Hammad Hall",  # جردم split across text runs
    "داحم جر دم":   "Hammad Hall",  # alternate encoding, split
    "دامح":         "Hammad Hall",  # partial (just "Hammad")
    "داحم":         "Hammad Hall",  # alternate encoding, partial
}

# Known hall name suffixes used to build display names for unlisted halls.
# These Arabic words mean "hall" / "auditorium" in the PDF's visual order.
_HALL_MARKERS = ("جردم",)

# Maps reversed pdfplumber Arabic name fragments → English hall names.
# Used by the general hall detector when the full key is not in LOCATION_MAP.
_HALL_NAMES = {
    "دامح":  "Hammad",
    "داحم":  "Hammad",   # alternate PDF encoding variant
    "لاله":  "Hilal",
    "للاه":  "Hilal",
    "حون":   "Noah",
    "يزاجح": "Hegazy",
    "ىزاجح": "Hegazy",
}

# Arabic words that indicate a "department" location
_DEPT_MARKERS = ("مسقلا", "مسق", "مسفلا")

# ─── Regex for a time range: "8-11", "11–8", "4.30-2.30" ────────────────────
_TIME_RE = re.compile(r'^\d{1,2}(?:[.:]\d{1,2})?[-–−]\d{1,2}(?:[.:]\d{1,2})?$')
# Regex for a course code like MATH102, PHYS 106, COMP104
_CODE_RE = re.compile(r'^[A-Z]{2,6}\s*\d{3,4}[A-Z]?$')


def _normalize_ar(s):
    """Normalize Arabic text for fuzzy matching.
    Removes kashida, unifies alef-maqsura (ى) with ya (ي), and collapses spaces.
    """
    s = re.sub(r'ـ+', '', s)           # remove kashida (U+0640)
    s = s.replace('ى', 'ي')   # ى → ي (alef maqsura, identical visually)
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def normalize_time(raw):
    """
    Convert time range string like '11-8', '8-11', '4.30-2.30' to a
    (start, end) pair in HH:MM 24-hour format.
    Schedule hours: 07:00 – 18:30.
    """
    if not raw:
        return None, None
    # Unify separators and strip spaces
    cleaned = raw.strip().replace("–", "-").replace("−", "-").replace(" ", "")
    parts = cleaned.split("-")
    if len(parts) != 2:
        return None, None

    def parse_minutes(s):
        s = s.replace(":", ".")  # treat colon same as dot
        if "." in s:
            h_str, m_str = s.split(".", 1)
            return int(h_str) * 60 + int(m_str.ljust(2, "0")[:2])
        return int(s) * 60

    def to24(total_min):
        h = total_min // 60
        if 1 <= h <= 6:          # 1-6 → afternoon (PM)
            total_min += 12 * 60
        return total_min

    try:
        ta = to24(parse_minutes(parts[0]))
        tb = to24(parse_minutes(parts[1]))
        s_min, e_min = min(ta, tb), max(ta, tb)
        if s_min < 7 * 60 or e_min > 18 * 60 + 30:
            return None, None
        return f"{s_min // 60:02d}:{s_min % 60:02d}", f"{e_min // 60:02d}:{e_min % 60:02d}"
    except (ValueError, TypeError):
        return None, None


def normalize_code(raw):
    if not raw or raw.strip() in ("--", "-", "", "None"):
        return None
    cleaned = re.sub(r'\s+', '', raw.strip().upper())
    if re.match(r'^[A-Z]{2,6}\d{3,4}[A-Z]?$', cleaned):
        return cleaned
    return None


def _classify_cell(cell):
    """
    Classify a table cell string into one of:
      'day'     → value is the English day name
      'time'    → value is the normalised time string (e.g. "8-11")
      'code'    → value is the normalised course code
      'lesson'  → value is the English lesson type
      'credits' → value is an int
      'location'→ value is translated location string
      'text'    → unclassified Arabic/other text (likely course name)
      None      → empty cell
    """
    if not cell:
        return None, None
    s = cell.strip()
    if not s:
        return None, None

    # Flatten multi-line content into a single space-separated string.
    # pdfplumber splits RTL time ranges across lines, e.g. "11 8\n-" for "8-11".
    flat = ' '.join(s.split())
    # ى→ي normalized (alef-maqsura / ya unification)
    flat_yi = flat.replace('ى', 'ي')
    # kashida-stripped + ى→ي (catches e.g. "تـبسلا" → "تبسلا" = Saturday)
    flat_clean = re.sub(r'ـ+', '', flat_yi)

    # Day — check all normalization levels
    for candidate in (s, flat, flat_yi, flat_clean):
        if candidate in DAY_MAP:
            return 'day', DAY_MAP[candidate]

    # Time range — handles "8-11", "11-8", "4.30-2.30", and the multi-line
    # PDF format "11 8\n-" (flattened to "11 8 -").
    time_flat = flat.replace('–', '-').replace('−', '-').rstrip(' -').strip()
    # Convert "N1 N2" (two numbers with space, hyphen stripped) → "N1-N2"
    time_candidate = re.sub(
        r'^(\d{1,2}(?:[.:]\d{1,2})?)\s+(\d{1,2}(?:[.:]\d{1,2})?)$',
        r'\1-\2',
        time_flat,
    )
    if _TIME_RE.match(time_candidate.replace(' ', '')):
        return 'time', time_candidate

    # Course code (Latin, may have space "MATH 102" or reversed "102\nMATH")
    upper = flat.upper()
    code_nospace = re.sub(r'\s+', '', upper)
    if _CODE_RE.match(upper) or _CODE_RE.match(code_nospace):
        return 'code', code_nospace
    # Reversed format: "102 MATH" → "MATH102"
    rev = re.match(r'^(\d{3,4}[A-Z]?)\s+([A-Z]{2,6})$', upper)
    if rev:
        return 'code', rev.group(2) + rev.group(1)

    # Lesson type (raw, flat, ى-normalized, kashida-stripped)
    for candidate in (s, flat, flat_yi, flat_clean):
        if candidate in LESSON_TYPE_MAP:
            return 'lesson', LESSON_TYPE_MAP[candidate]

    # Credits: a single digit 1–6
    if re.match(r'^\d$', flat) and 1 <= int(flat) <= 6:
        return 'credits', int(flat)

    # Known location keyword (raw, flat, ى-normalized, kashida-stripped)
    for candidate in (s, flat, flat_yi, flat_clean):
        if candidate in LOCATION_MAP:
            return 'location', LOCATION_MAP[candidate]

    # Room/section number pattern: "101 ةعاق", "9 لصف", "101 ) ( ةعاق" etc.
    # Only match when a known Arabic room/section word is present.
    _ROOM_WORDS = ('ةعاق', 'هعاق', 'لصف')
    if any(w in flat_clean for w in _ROOM_WORDS) and not re.search(r'[A-Za-z]', flat_clean):
        room_m = re.search(r'\b(\d+)\b', flat_clean)
        if room_m:
            return 'location', f"Room {room_m.group(1)}"
        # Classroom with letter label but no number (e.g. bare "ةعاق")
        return 'location', 'Classroom'

    # General hall detection: any cell containing the Arabic hall marker "جردم"
    # catches halls not listed in LOCATION_MAP (e.g. "نيمأ جردم" → "نيمأ Hall").
    for marker in _HALL_MARKERS:
        if marker in flat_clean:
            name_part = flat_clean.replace(marker, '').strip()
            if not name_part:
                return 'location', 'Hall'
            # Look up the Arabic fragment in _HALL_NAMES; try ى→ي normalised too
            english = _HALL_NAMES.get(name_part) or _HALL_NAMES.get(name_part.replace('ى', 'ي'))
            return 'location', f"{english or name_part} Hall"

    # General department detection: "مسق" substring not already caught above
    for dept_kw in _DEPT_MARKERS:
        if dept_kw in flat_clean:
            return 'location', 'Department'

    # Anything else: treat as text (course name or unmapped location)
    return 'text', flat


def is_header_row(row):
    if not row:
        return False
    joined = " ".join(str(c) for c in row if c)
    # Reversed Arabic for "اليوم" (day), "الساعات" (hours), "الدرس" (lesson)
    return any(h in joined for h in ["مويلا", "موـيلا", "تاعاسلا", "سردلا", "ةداملا"])


def get_program_name(page):
    """
    Extract the program name from a page.
    Scans all non-header text lines and matches against PROGRAM_MAP,
    normalising kashida before comparing.
    """
    text = page.extract_text()
    if not text:
        return None

    # Lines to skip (standard page header / footer)
    SKIP_FRAGMENTS = [
        "office of the vice dean",
        "academic year",
        "|p a g e",
        "p a g e",
    ]

    lines = [l.strip() for l in text.split("\n") if l.strip()]

    for line in lines:
        ll = line.lower()
        if any(frag in ll for frag in SKIP_FRAGMENTS):
            continue
        if re.match(r'^\|?\s*[Pp]\s*a\s*g\s*e', line):
            continue

        norm_line = _normalize_ar(line)

        # Skip lines too short to be a program name (avoids single letters like
        # 'ب' matching as a substring inside every key).
        if len(norm_line.replace(' ', '')) < 5:
            continue

        # Exact match
        if norm_line in PROGRAM_MAP:
            return PROGRAM_MAP[norm_line]

        # Fuzzy match: substring check with and without spaces
        # (handles kashida, ى/ي variants, missing spaces, and partial lines)
        norm_line_ns = norm_line.replace(' ', '')
        for k, v in PROGRAM_MAP.items():
            nk = _normalize_ar(k)
            if nk in norm_line or norm_line in nk:
                return v
            nk_ns = nk.replace(' ', '')
            # Require the shorter side to be at least 5 chars to avoid
            # single-word / short-token false positives.
            shorter = min(len(nk_ns), len(norm_line_ns))
            if shorter >= 5 and (nk_ns in norm_line_ns or norm_line_ns in nk_ns):
                return v

    return None


def extract_page_schedules(page, program_name, semester, academic_year):
    """
    Extract schedule entries from a single page.
    Uses content-based cell classification instead of fixed column indices,
    so column order in the pdfplumber output doesn't matter.
    """
    tables = page.extract_tables()
    if not tables:
        return []

    entries = []
    current_day = None

    for table in tables:
        for row in table:
            if is_header_row(row):
                continue
            if not row or len(row) < 4:
                continue

            # Classify every cell in this row
            day_val      = None
            time_raw     = None
            code_val     = None
            lesson_val   = None
            credits_val  = None
            location_val = None
            text_cells   = []   # unclassified text → candidate for course name

            for cell in row:
                ctype, cval = _classify_cell(cell)
                if ctype is None:
                    continue
                elif ctype == 'day':
                    day_val = cval
                elif ctype == 'time':
                    time_raw = cval
                elif ctype == 'code':
                    code_val = cval
                elif ctype == 'lesson':
                    lesson_val = cval
                elif ctype == 'credits':
                    credits_val = cval
                elif ctype == 'location':
                    location_val = cval
                elif ctype == 'text':
                    text_cells.append(cval)

            # Update running day tracker
            if day_val:
                current_day = day_val

            # Course name: longest unclassified text cell
            course_name = max(text_cells, key=len) if text_cells else None

            # Need at least a code or course name to be useful
            if not code_val and not course_name:
                continue

            start_time, end_time = normalize_time(time_raw)
            lesson_type = lesson_val or "LECTURE"
            is_elective = lesson_val is None and time_raw is not None and "خ" in (time_raw or "")

            # Clean up course name whitespace
            if course_name:
                course_name = " ".join(course_name.split())

            entries.append({
                "courseCode":   code_val,
                "courseName":   course_name,
                "dayOfWeek":    current_day,
                "startTime":    start_time,
                "endTime":      end_time,
                "location":     location_val,
                "lessonType":   lesson_type,
                "isElective":   is_elective,
                "creditHours":  credits_val,
                "program":      program_name,
                "semester":     semester,
                "academicYear": academic_year,
            })

    return entries


def scrape_pdf(pdf_path, semester="Spring", academic_year="2025/2026"):
    all_entries    = []
    programs_found = []
    prev_program   = None   # carry-forward when a page loses its header

    with pdfplumber.open(pdf_path) as pdf:
        for page_num, page in enumerate(pdf.pages[1:], start=2):
            program_name = get_program_name(page)

            # If detection failed but we have a recent program, carry it forward.
            # This covers Biology group pages whose header omits the program line.
            if program_name is None and prev_program is not None:
                program_name = prev_program

            if program_name and program_name not in programs_found:
                programs_found.append(program_name)

            if program_name:
                prev_program = program_name

            page_entries = extract_page_schedules(
                page,
                program_name or f"Unknown (page {page_num})",
                semester,
                academic_year,
            )
            all_entries.extend(page_entries)

    # Deduplicate by (code, day, startTime, lessonType).
    # The same lecture appears on every program page (all programs share the same
    # room/time for a given course), so program is NOT part of the key.
    # The first occurrence (from the course's own department page) is kept.
    seen   = set()
    unique = []
    for e in all_entries:
        key = (e["courseCode"], e["dayOfWeek"], e["startTime"], e["lessonType"])
        if key not in seen:
            seen.add(key)
            unique.append(e)

    return {
        "success":      True,
        "totalEntries": len(unique),
        "programs":     programs_found,
        "schedules":    unique,
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
        result     = scrape_pdf(args.pdf_path, args.semester, args.academic_year)
        output_str = json.dumps(result, ensure_ascii=False, indent=2)
        if args.output:
            Path(args.output).write_text(output_str, encoding="utf-8")
            sys.stderr.write(
                f"OK {result['totalEntries']} entries, "
                f"{len(result['programs'])} programs -> {args.output}\n"
            )
        else:
            sys.stdout.buffer.write(output_str.encode("utf-8"))
            sys.stdout.buffer.write(b"\n")
    except Exception as exc:
        import traceback
        print(json.dumps(
            {"success": False, "error": str(exc), "trace": traceback.format_exc()},
            ensure_ascii=False,
        ))
        sys.exit(1)


if __name__ == "__main__":
    main()
