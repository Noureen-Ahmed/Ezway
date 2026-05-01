"""
Gunicorn production config for the UMS scraper service.

Worker model: gthread (1 process + N threads).
- The scraper is IO-bound (network waits on UMS), so threads beat processes.
- A single process keeps RAM low on Railway's free/starter tier.
- Each /scrape/all call uses 4 internal threads for parallel page fetches,
  so the gunicorn thread count only needs to handle request concurrency.
"""

import multiprocessing
import os

# ── Bind ──────────────────────────────────────────────────────────────────────
bind = f"0.0.0.0:{os.getenv('PORT', '5000')}"

# ── Workers ───────────────────────────────────────────────────────────────────
workers      = 1
threads      = int(os.getenv("GUNICORN_THREADS", str(multiprocessing.cpu_count() * 2 + 1)))
worker_class = "gthread"

# ── Timeouts ──────────────────────────────────────────────────────────────────
# UMS portal can be slow; 90s covers worst-case login + 4 page fetches.
timeout          = 90
graceful_timeout = 20
keepalive        = 5

# ── Queue ─────────────────────────────────────────────────────────────────────
backlog = 64

# ── Logging ───────────────────────────────────────────────────────────────────
accesslog          = "-"
errorlog           = "-"
loglevel           = os.getenv("LOG_LEVEL", "info")
access_log_format  = '%(h)s "%(r)s" %(s)s %(b)sB in %(D)sµs'
capture_output     = True

# ── Security ──────────────────────────────────────────────────────────────────
limit_request_line   = 4094
limit_request_fields = 100
