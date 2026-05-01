"""
HTTP-based UMS session management.

Login flow (no browser needed):
  1. GET /App/Login_Form  →  grab CSRF token + ASP.NET session cookie
  2. POST credentials + CSRF token  →  follow redirect
  3. If still on Login_Form: wrong password; else: authenticated

After login the caller receives a cookie-header string that is safe
to share across threads for parallel page fetches.
"""

import logging

import requests
from bs4 import BeautifulSoup
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

from .config import (
    BASE_HEADERS,
    CONNECT_TIMEOUT,
    MAX_RETRIES,
    READ_TIMEOUT,
    UMS_BASE,
    URLS,
    DEFAULT_DOMAIN,
)

logger = logging.getLogger(__name__)


def _build_session() -> requests.Session:
    """requests.Session with retry policy and connection pooling."""
    retry = Retry(
        total=MAX_RETRIES,
        backoff_factor=0.5,
        status_forcelist=[429, 500, 502, 503, 504],
        allowed_methods=["GET", "POST"],
        raise_on_status=False,
    )
    adapter = HTTPAdapter(
        max_retries=retry,
        pool_connections=4,
        pool_maxsize=10,
    )
    session = requests.Session()
    session.mount("https://", adapter)
    session.mount("http://",  adapter)
    session.headers.update(BASE_HEADERS)
    return session


def _extract_csrf(html: str) -> str | None:
    soup = BeautifulSoup(html, "lxml")
    el = soup.find("input", {"name": "__RequestVerificationToken"})
    return el["value"] if el else None


def login(username: str, password: str) -> str:
    """
    Authenticate against UMS.

    Returns a cookie-header string (e.g. "ASP.NET_SessionId=abc; .ASPXAUTH=xyz")
    that can be attached to any subsequent request.

    Raises:
        ValueError  — wrong username / password
        RuntimeError — network / parsing problem
    """
    login_id = username.split("@")[0] if "@" in username else username
    domain   = f"@{username.split('@')[1]}" if "@" in username else DEFAULT_DOMAIN

    session = _build_session()

    # ── Step 1: GET login page ────────────────────────────────────────────────
    logger.info("Fetching login page for CSRF token...")
    try:
        resp = session.get(
            URLS["login"],
            timeout=(CONNECT_TIMEOUT, READ_TIMEOUT),
        )
        resp.raise_for_status()
    except requests.RequestException as exc:
        raise RuntimeError(f"Cannot reach UMS login page: {exc}") from exc

    csrf_token = _extract_csrf(resp.text)
    logger.debug("CSRF token present: %s", bool(csrf_token))

    # ── Step 2: POST credentials ──────────────────────────────────────────────
    payload: dict[str, str] = {
        "LoginName":  login_id,
        "password":   password,
        "DomainName": domain,
    }
    if csrf_token:
        payload["__RequestVerificationToken"] = csrf_token

    logger.info("Submitting login for %s%s", login_id, domain)
    try:
        post_resp = session.post(
            URLS["login"],
            data=payload,
            headers={
                "Content-Type": "application/x-www-form-urlencoded",
                "Referer": URLS["login"],
                "Origin":  UMS_BASE,
            },
            timeout=(CONNECT_TIMEOUT, READ_TIMEOUT),
            allow_redirects=True,
        )
    except requests.RequestException as exc:
        raise RuntimeError(f"Login POST failed: {exc}") from exc

    # ── Step 3: Verify success ────────────────────────────────────────────────
    if "Login_Form" in post_resp.url or post_resp.status_code == 401:
        soup = BeautifulSoup(post_resp.text, "lxml")
        err_el = soup.select_one(
            ".validation-summary-errors, .text-danger, .alert-danger"
        )
        err_msg = err_el.get_text(strip=True) if err_el else "Invalid credentials"
        logger.warning("Login rejected for %s: %s", login_id, err_msg)
        raise ValueError(err_msg)

    if not session.cookies:
        raise RuntimeError("Login appeared to succeed but no cookies were set")

    cookie_header = "; ".join(
        f"{c.name}={c.value}" for c in session.cookies
    )
    logger.info(
        "Login succeeded — %d cookies, redirected to: %s",
        len(session.cookies),
        post_resp.url,
    )
    return cookie_header


# A module-level session reused across fetch_page calls for connection pooling.
_fetch_session: requests.Session | None = None


def _get_fetch_session() -> requests.Session:
    global _fetch_session
    if _fetch_session is None:
        _fetch_session = _build_session()
    return _fetch_session


def fetch_page(cookie_header: str, url: str) -> str:
    """
    Fetch an authenticated UMS page.
    Thread-safe: passes cookies as a header string (no shared mutable state).

    Raises:
        RuntimeError — session expired or request error
    """
    sess = _get_fetch_session()
    try:
        resp = sess.get(
            url,
            headers={
                "Cookie":  cookie_header,
                "Referer": UMS_BASE,
            },
            timeout=(CONNECT_TIMEOUT, READ_TIMEOUT),
        )
        resp.raise_for_status()
    except requests.RequestException as exc:
        raise RuntimeError(f"Fetch failed for {url}: {exc}") from exc

    if "Login_Form" in resp.url:
        raise RuntimeError("UMS session expired — re-login required")

    return resp.text
