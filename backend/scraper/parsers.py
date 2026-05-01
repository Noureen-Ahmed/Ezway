"""
BeautifulSoup + lxml parsers for UMS portal pages.

Each parser uses multiple fallback strategies because the UMS HTML
layout varies between faculties and Kendo-rendered vs server-rendered views.
"""

import logging
import re

from bs4 import BeautifulSoup

logger = logging.getLogger(__name__)

# ── Shared cleaning utilities ─────────────────────────────────────────────────

_KENDO_RE   = re.compile(r"activate\s+to\s+sort\s+column\s+(ascending|descending)", re.I)
_WHITESPACE = re.compile(r"\s{2,}")
_JUNK_ONLY  = re.compile(r"^[:\-,>\"'\s]+$")
_HTML_TAG   = re.compile(r"<[^>]*>")

# Arabic field-header strings that sometimes leak into values
_HEADER_STRINGS = frozenset(
    ["الاسم", "العنوان", "الهاتف", "الموبايل", "تليفون", "الكلية", "البرنامج", "القومي"]
)


def _clean(text: str | None) -> str | None:
    if not text:
        return None
    text = _KENDO_RE.sub("", text)
    text = _HTML_TAG.sub("", text)
    text = text.strip(" \t\n\r\">':")
    text = _WHITESPACE.sub(" ", text).strip()
    if not text or _JUNK_ONLY.match(text) or text in _HEADER_STRINGS:
        return None
    return text


def _to_float(s: str) -> float | None:
    try:
        return float(s.strip())
    except (ValueError, TypeError, AttributeError):
        return None


def _to_int(s: str) -> int | None:
    try:
        return int(s.strip())
    except (ValueError, TypeError, AttributeError):
        return None


# ── Profile field label → dict key ───────────────────────────────────────────

def _label_to_key(label: str) -> str | None:
    if re.search(r"القومي|رقم قومي|SSN",             label):          return "studentId"
    if re.search(r"جواز|Passport",                    label):          return "passportNumber"
    if re.search(r"بالعربية|Arabic",                  label):          return "nameAr"
    if re.search(r"بالإنجليزية|English",              label):          return "nameEn"
    if re.search(r"الإلكتروني|email",                 label, re.I):    return "email"
    if re.search(r"الهاتف|تليفون|موبايل|Mobile|phone", label, re.I):  return "phone"
    if re.search(r"الكلية|Faculty|كلية",              label):          return "faculty"
    if re.search(r"القسم|Department|قسم",             label):          return "department"
    if re.search(r"البرنامج|Program",                 label):          return "program"
    if re.search(r"العنوان|address",                  label, re.I):    return "address"
    if re.search(r"المستوى|Level",                    label, re.I):    return "level"
    if re.search(r"الفصل|semester",                   label, re.I):    return "semester"
    if re.search(r"الأكاديمية|السنة|academicYear",    label):          return "academicYear"
    return None


# ── Parsers ───────────────────────────────────────────────────────────────────

def parse_profile(html: str) -> dict:
    """
    Parse /UserInformation HTML.

    Strategy 1 — div.row > h5 (label) + p/span (value): standard card layout
    Strategy 2 — dl > dt + dd: definition-list layout
    Strategy 3 — 2-column table rows
    Strategy 4 — 12-column Kendo DataTable row that contains an email address
    Strategy 5 — nav-bar user link as last-resort name fallback
    """
    if not html:
        return {}

    soup = BeautifulSoup(html, "lxml")
    profile: dict[str, str | int] = {}

    def _set(key: str | None, raw_val: str | None) -> None:
        if key and raw_val and key not in profile:
            v = _clean(raw_val)
            if v:
                profile[key] = v

    # Strategy 1: div.row > h5 + p/span
    for row in soup.find_all("div", class_="row"):
        h5     = row.find("h5")
        val_el = row.find("p") or row.find("span")
        if h5 and val_el:
            _set(_label_to_key(h5.get_text(strip=True)), val_el.get_text(strip=True))

    # Strategy 2: dl > dt + dd
    for dl in soup.find_all("dl"):
        for dt in dl.find_all("dt"):
            dd = dt.find_next_sibling("dd")
            if dd:
                _set(_label_to_key(dt.get_text(strip=True)), dd.get_text(strip=True))

    # Strategy 3: 2-column tables
    for table in soup.find_all("table"):
        for row in table.find_all("tr"):
            cells = row.find_all("td")
            if len(cells) == 2:
                _set(
                    _label_to_key(cells[0].get_text(strip=True)),
                    cells[1].get_text(strip=True),
                )

    # Strategy 4: 12-col Kendo DataTable — find the row with an email cell
    if "nameAr" not in profile:
        for row in soup.select("table tbody tr"):
            cells = row.find_all("td")
            if len(cells) >= 12 and any("@" in c.get_text() for c in cells):
                _set("nameAr",  cells[2].get_text(strip=True))
                _set("nameEn",  cells[3].get_text(strip=True))
                _set("email",   cells[4].get_text(strip=True))
                _set("address", cells[8].get_text(strip=True))
                _set("phone",   cells[9].get_text(strip=True))
                break

    # Strategy 5: nav-bar user icon link
    if "nameAr" not in profile:
        for a in soup.find_all("a"):
            if a.find(class_="fa-user"):
                text = a.get_text(strip=True)
                if text and text != "الصفحة الشخصية":
                    profile["nameAr"] = text
                    break

    # Derive numeric level from text (e.g. "المستوى الثالث" → 3)
    if profile.get("level"):
        m = re.search(r"(\d+)", str(profile["level"]))
        if m:
            profile["levelNum"] = int(m.group(1))

    logger.info("Profile fields parsed: %s", list(profile.keys()))
    return profile


def parse_courses(html: str) -> list[dict]:
    """
    Parse /UserInformation/CurrentCourse.

    Strategy 1 — div.price-table-box2 cards (most common on sci.asu)
    Strategy 2 — h5.text-dark with [COURSE CODE] format
    Strategy 3 — standard HTML table rows
    """
    if not html:
        return []

    soup = BeautifulSoup(html, "lxml")
    courses: list[dict] = []

    # Strategy 1: course cards
    cards = soup.find_all("div", class_="price-table-box2")
    if cards:
        logger.info("Courses: %d cards found (strategy 1)", len(cards))
        for card in cards:
            course: dict = {}
            title_el = card.find("h5")
            if title_el:
                full = title_el.get_text(strip=True)
                m = re.search(r"\[([^\]]+)\]", full)
                if m:
                    course["courseCode"] = m.group(1).strip()
                    course["courseName"] = full[: full.rfind("[")].strip()
                else:
                    course["courseName"] = full
                    course["courseCode"] = ""

            grades: dict[str, float] = {}
            for row in card.find_all("div", class_="row"):
                parts = row.get_text(separator="|", strip=True).split("|")
                for i in range(len(parts) - 1):
                    label, val_str = parts[i].strip(), parts[i + 1].strip()
                    val = _to_float(val_str)
                    if val is None:
                        continue
                    if "تحريري" in label:
                        grades["written"] = val
                    elif "عملي" in label:
                        grades["practical"] = val
                    elif "شفوي" in label:
                        grades["oral"] = val
                    elif "أعمال" in label or "اعمال" in label:
                        grades["semesterWork"] = val

            course["grades"]         = grades
            course["creditHours"]    = None
            course["section"]        = None
            course["instructorName"] = None

            if course.get("courseCode") or course.get("courseName"):
                courses.append(course)
        return courses

    # Strategy 2: h5.text-dark with [CODE]
    for h5 in soup.select("h5.text-dark"):
        text = h5.get_text(strip=True)
        m = re.search(r"(.*)\[(.*)\]", text)
        if m:
            courses.append(
                {
                    "courseCode":    m.group(2).strip(),
                    "courseName":    m.group(1).strip(),
                    "creditHours":   None,
                    "grades":        {},
                    "section":       None,
                    "instructorName": None,
                }
            )
    if courses:
        logger.info("Courses: %d found (strategy 2)", len(courses))
        return courses

    # Strategy 3: table rows
    for table in soup.find_all("table"):
        for i, row in enumerate(table.find_all("tr")):
            if i == 0:
                continue
            cells = row.find_all("td")
            if len(cells) >= 2:
                code = cells[0].get_text(strip=True)
                if code and len(code) > 1:
                    courses.append(
                        {
                            "courseCode":    code,
                            "courseName":    cells[1].get_text(strip=True),
                            "creditHours":   _to_int(cells[2].get_text(strip=True)) if len(cells) > 2 else None,
                            "section":       cells[3].get_text(strip=True) if len(cells) > 3 else None,
                            "instructorName": cells[4].get_text(strip=True) if len(cells) > 4 else None,
                            "grades":        {},
                        }
                    )

    logger.info("Courses: %d found (strategy 3)", len(courses))
    return courses


def parse_advisor(html: str) -> dict:
    """Parse /RegisterElectiveCourse/Registration for advisor name + email."""
    if not html:
        return {}

    soup = BeautifulSoup(html, "lxml")
    text = soup.get_text()
    info: dict[str, str] = {}

    name_m = re.search(
        r"للمرشد الأكاديم[يى]\s*:?\s*([^\n\r<]{2,80})"
        r"|المرشد\s*:?\s*([^\n\r<]{2,80})",
        text,
    )
    email_m = re.search(r"mailto:([^\"'\s>]+)", html, re.I)

    if name_m:
        info["advisorName"]  = (name_m.group(1) or name_m.group(2)).strip()
    if email_m:
        info["advisorEmail"] = email_m.group(1).strip()

    logger.info("Advisor parsed: %s", info)
    return info


def parse_grades(html: str) -> list[dict]:
    """Parse /StudentGrades — table with code, name, grade, points, hours."""
    if not html:
        return []

    soup = BeautifulSoup(html, "lxml")
    grades: list[dict] = []

    for table in soup.find_all("table"):
        for i, row in enumerate(table.find_all("tr")):
            if i == 0:
                continue
            cells = row.find_all("td")
            if len(cells) >= 2:
                code = cells[0].get_text(strip=True)
                if code and len(code) > 1:
                    grades.append(
                        {
                            "courseCode":  code,
                            "courseName":  cells[1].get_text(strip=True) if len(cells) > 1 else "",
                            "grade":       cells[2].get_text(strip=True) if len(cells) > 2 else None,
                            "gradePoints": _to_float(cells[3].get_text(strip=True)) if len(cells) > 3 else None,
                            "creditHours": _to_int(cells[4].get_text(strip=True))   if len(cells) > 4 else None,
                        }
                    )

    logger.info("Grades: %d rows parsed", len(grades))
    return grades
