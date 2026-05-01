import os

UMS_BASE = "https://ums.asu.edu.eg"

URLS = {
    "login":    f"{UMS_BASE}/App/Login_Form",
    "profile":  f"{UMS_BASE}/UserInformation",
    "courses":  f"{UMS_BASE}/UserInformation/CurrentCourse",
    "advisor":  f"{UMS_BASE}/RegisterElectiveCourse/Registration",
    "grades":   f"{UMS_BASE}/StudentGrades",
}

DEFAULT_DOMAIN = "@sci.asu.edu.eg"

BASE_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/120.0.0.0 Safari/537.36"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "ar,en-US;q=0.9,en;q=0.8",
    "Accept-Encoding": "gzip, deflate, br",
    "Connection": "keep-alive",
}

CONNECT_TIMEOUT = int(os.getenv("UMS_CONNECT_TIMEOUT", "10"))
READ_TIMEOUT    = int(os.getenv("UMS_READ_TIMEOUT",    "25"))
MAX_RETRIES     = int(os.getenv("UMS_MAX_RETRIES",     "3"))
