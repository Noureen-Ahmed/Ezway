# Schedule PDF Scraper — Integration Guide

Extracts course timetables from the Ain Shams Faculty of Science schedule PDF
and imports them into your existing Prisma/MySQL database.

## Architecture

```
Flutter Admin Page
      │  POST /api/schedule/upload  (multipart PDF)
      ▼
Node.js Express API  (scheduleRoutes.js)
      │  spawn('python3 scrape_schedule.py <pdf>')
      ▼
Python Scraper  (scrape_schedule.py)
      │  returns JSON via stdout
      ▼
scheduleImporter.js
      │  upsert Course + insert CourseSchedule rows
      ▼
MySQL via Prisma  (existing schema — no migrations needed)
```

---

## 1. Python Setup

### Install dependencies
```bash
pip install pdfplumber
# or: pip3 install pdfplumber --break-system-packages
```

### Test manually
```bash
python3 python/scrape_schedule.py path/to/schedule.pdf --output /tmp/test.json
# Or pipe to stdout:
python3 python/scrape_schedule.py path/to/schedule.pdf | jq .totalEntries
```

---

## 2. Node.js Setup

### Install npm packages
```bash
cd nodejs
npm install
```

### Environment variables (add to your .env)
```env
# Already in your .env:
DATABASE_URL="mysql://..."

# Optional — only needed if python3 isn't in PATH:
PYTHON_BIN=python3

# Optional — upload temp directory:
UPLOAD_DIR=/tmp/schedule-uploads
```

### Mount the routes in your existing Express app
```js
// In your existing app.js / server.js:
const scheduleRoutes = require('./src/scheduleRoutes');
app.use('/api/schedule', scheduleRoutes);
```

Or run the standalone server for testing:
```bash
cd nodejs
npm start  # starts on port 3001
```

---

## 3. API Endpoints

### `POST /api/schedule/upload`
Scrapes the PDF and imports to DB. Replaces existing schedule slots for
the matching semester/year/courses.

**Form data:**
| Field         | Type    | Required | Default      |
|---------------|---------|----------|--------------|
| `file`        | PDF     | ✅       | —            |
| `semester`    | string  | ❌       | `"Spring"`   |
| `academicYear`| string  | ❌       | `"2025/2026"`|
| `dryRun`      | boolean | ❌       | `false`      |

**Response:**
```json
{
  "success": true,
  "report": {
    "scrapedEntries": 292,
    "programs": ["Mathematics", "Computer Science", "..."],
    "coursesUpdated": 87,
    "schedulesInserted": 241,
    "schedulesSkipped": 51,
    "errors": [],
    "durationMs": 1842
  }
}
```

### `POST /api/schedule/preview`
Same as upload but returns raw scraped data without touching the DB.

### `GET /api/schedule/status`
Returns current DB schedule/course counts.

---

## 4. Flutter Setup

Copy `flutter/schedule_importer_page.dart` into your Flutter project.

### pubspec.yaml dependencies
```yaml
dependencies:
  file_picker: ^6.0.0
  http: ^1.1.0
  http_parser: ^4.0.2
```

### Usage
```dart
// In your admin navigation:
Navigator.push(context, MaterialPageRoute(
  builder: (_) => const ScheduleImporterPage(),
));
```

### Update the API base URL
In `schedule_importer_page.dart`, line ~30:
```dart
static const String _apiBase = 'https://your-api.com/api/schedule';
```

---

## 5. How the Scraper Works

The PDF has one program per page. Each page contains a table with columns:
```
Location | Course Name (Arabic) | Time | Credit Hours | Code | Type | Day
```

**Key handling:**
- **Arabic text** — pdfplumber returns RTL Arabic in visual order
  (characters reversed). Day names are mapped from their visual-order form.
- **Time conversion** — Hours 1–6 are PM (add 12); hours 7–12 are AM.
  e.g. "5-2" → 14:00–17:00 (2pm–5pm).
- **Day persistence** — Day column uses merged cells; the scraper carries
  forward the last seen day value across rows.
- **Deduplication** — Entries with the same (courseCode, day, startTime,
  program, lessonType) are deduplicated.

---

## 6. Supported Programs (23 total)

Mathematics, Pure Mathematics & CS, Mathematical Statistics & CS,
Computer Science, Physics, Biophysics, Physics & Chemistry,
Physics & CS, Chemistry, Applied Chemistry, Botany, Botany & Chemistry,
Zoology, Zoology & Chemistry, Entomology & Chemistry, Biochemistry,
Biochemistry & Chemistry, Microbiology, Microbiology & Chemistry,
Geology, Geology & Chemistry, Geology & Geophysics, Geophysics

---

## 7. File Structure

```
schedule-scraper/
├── python/
│   └── scrape_schedule.py       ← PDF scraper (run by Node.js)
├── nodejs/
│   ├── package.json
│   ├── SCHEMA_NOTES.md          ← Notes on Prisma schema mapping
│   └── src/
│       ├── index.js             ← Standalone Express server (optional)
│       ├── scheduleRoutes.js    ← Express routes (mount in your app)
│       └── scheduleImporter.js  ← Core import logic
└── flutter/
    └── schedule_importer_page.dart  ← Admin UI page
```
