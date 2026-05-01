"""
UMS Scraper Service v4 — Flask API.

No Playwright. No Chromium. No browser.

Login:   requests.Session  (HTTP POST + CSRF token, same approach already
         proven in ums.service.js)
Scrape:  BeautifulSoup + lxml  (4 pages in parallel via ThreadPoolExecutor)

Endpoints:
  GET  /health     — liveness probe
  POST /scrape/all — authenticate + return full UMS data
"""

import concurrent.futures
import logging
import os
import sys

from flask import Flask, jsonify, request

from scraper.config import URLS
from scraper.parsers import parse_advisor, parse_courses, parse_grades, parse_profile
from scraper.session import fetch_page, login

# ── Logging ───────────────────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)-8s %(name)s — %(message)s",
    stream=sys.stdout,
)
logger = logging.getLogger(__name__)

# ── Flask ─────────────────────────────────────────────────────────────────────

app = Flask(__name__)
app.json.ensure_ascii = False  # Preserve Arabic characters in JSON responses

# ── Core scrape logic ─────────────────────────────────────────────────────────

_PAGES = {
    "profile": URLS["profile"],
    "courses": URLS["courses"],
    "advisor": URLS["advisor"],
    "grades":  URLS["grades"],
}


def _scrape(username: str, password: str) -> dict:
    """
    1. Authenticate (HTTP, no browser).
    2. Fetch 4 UMS pages in parallel.
    3. Parse and return structured data.
    """
    cookie_header = login(username, password)

    html: dict[str, str] = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        future_to_name = {
            pool.submit(fetch_page, cookie_header, url): name
            for name, url in _PAGES.items()
        }
        for future in concurrent.futures.as_completed(future_to_name):
            name = future_to_name[future]
            try:
                html[name] = future.result()
            except Exception as exc:
                logger.warning("Page '%s' fetch error: %s", name, exc)
                html[name] = ""

    profile = parse_profile(html.get("profile", ""))
    profile.update(parse_advisor(html.get("advisor", "")))

    return {
        "profile": profile,
        "courses": parse_courses(html.get("courses", "")),
        "grades":  parse_grades(html.get("grades", "")),
    }


# ── Routes ────────────────────────────────────────────────────────────────────

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "service": "ums-scraper", "version": "4.0.0"})


@app.route("/scrape/all", methods=["POST"])
def scrape_all():
    body     = request.get_json(silent=True) or {}
    username = (body.get("username") or "").strip()
    password = (body.get("password") or "").strip()

    if not username or not password:
        return jsonify({"success": False, "error": "username and password are required"}), 400

    safe_user = username.split("@")[0] + "***"
    logger.info("Scrape request: %s", safe_user)

    try:
        data = _scrape(username, password)
        logger.info(
            "Scrape success for %s — %d courses, %d grades",
            safe_user, len(data["courses"]), len(data["grades"]),
        )
        return jsonify({"success": True, "data": data})

    except ValueError as exc:
        # Wrong credentials — do not log password
        logger.warning("Auth failure for %s: %s", safe_user, exc)
        return jsonify({"success": False, "error": str(exc)}), 401

    except RuntimeError as exc:
        logger.error("Scrape runtime error for %s: %s", safe_user, exc)
        return jsonify({"success": False, "error": str(exc)}), 502

    except Exception:
        logger.exception("Unexpected error for %s", safe_user)
        return jsonify({"success": False, "error": "Internal scraper error"}), 500


# ── Entry point ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    port = int(os.getenv("PORT", "5000"))
    logger.info("Starting UMS Scraper v4.0 on port %d", port)
    app.run(host="0.0.0.0", port=port, debug=False)
