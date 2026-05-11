<div align="center">

# EZway — Smart Academic Management System

**A cross-platform mobile and web application for Egyptian Faculty of Science academic operations**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-18+-339933?style=for-the-badge&logo=node.js&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-5.x-2D3748?style=for-the-badge&logo=prisma&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FCM-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Railway](https://img.shields.io/badge/Railway-Deployed-0B0D0E?style=for-the-badge&logo=railway&logoColor=white)

</div>


## Table of Contents

- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Tech Stack](#tech-stack)
- [Implementation Overview](#implementation-overview)
- [Database Schema](#database-schema)
- [API Reference](#api-reference)
- [User Roles & Workflows](#user-roles--workflows)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)
- [Project Structure](#project-structure)
- [Team](#team)

---

## Overview

**EZway** is a production-ready academic management platform built for Egyptian university students, professors, and administrators. It combines a Flutter cross-platform mobile app with a Node.js REST API, MySQL database, Firebase push notifications, and direct integration with the university's UMS portal — all in one unified system.

The platform eliminates the fragmentation of academic tools by providing a single application for course management, assignment submission, exam handling, grade tracking, scheduling, file uploads, and real-time notifications.

**Live API:** `https://ezway-production.up.railway.app/api`

---

## Problem Statement

Egyptian university students and faculty rely on disconnected, manual, or outdated tools for academic management:

- The UMS/ASU portal is web-only, slow, and has no real-time features
- Professors have no digital tool for content delivery, exam creation, or grading
- Students must visit multiple platforms to track deadlines, grades, and materials
- Announcements travel through informal channels (WhatsApp groups, verbal notices)
- Administrators have no unified view of enrollment, user activity, or course assignments

**EZway solves all of this in a single, integrated platform.**

---

## Features

### Students
- Login with existing UMS (university portal) credentials — no new account needed
- View all enrolled courses, schedules, and materials in one place
- Submit assignments with file attachments (PDF, DOC, images)
- Take timed exams with auto-submit on deadline
- Track grades, GPA, and submission history
- Receive real-time push notifications for new content, deadlines, and grades
- Browse a full student guide (30+ program and course screens by department/level)
- Personal calendar with academic events and deadlines
- Private notes management
- Built-in GPA calculator

### Professors
- Manage assigned courses with student enrollment visibility
- Upload lectures, materials, videos, and documents (organized by week)
- Create assignments with due dates, file attachments, and grading rubrics
- Build exams/quizzes with structured question sets
- Grade student submissions with points, letter grades, and written feedback
- Post course announcements — system automatically notifies enrolled students
- Track ungraded submissions with badge counts on the dashboard

### Administrators
- Web-based admin panel (served at `/admin`)
- View system statistics: total users, active courses, enrollments, recent signups
- Manage all users (create, edit, activate/deactivate, filter by role)
- Assign professors to courses
- Manage departments, programs, and faculties
- Upload schedule PDFs for bulk course schedule updates
- View course enrollment trends and task completion rates

---

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                         │
│                                                         │
│   Flutter App (Android / iOS / Web)                     │
│   ├── Student Dashboard                                 │
│   ├── Professor Dashboard                               │
│   └── Guest Mode                                        │
│                                                         │
│   Admin Web Panel (HTML5 / CSS3 / JS)                   │
│   └── Served at /admin                                  │
└─────────────────────┬───────────────────────────────────┘
                      │ HTTPS / REST API
┌─────────────────────▼───────────────────────────────────┐
│                   API LAYER (Railway)                    │
│                                                         │
│   Node.js 18 + Express.js                               │
│   ├── JWT Authentication Middleware                     │
│   ├── Role-Based Access Control                         │
│   ├── Rate Limiting (100 req / 15 min)                  │
│   ├── Helmet Security Headers                           │
│   └── 14 Route Modules                                  │
└──────────┬──────────┬────────────┬────────────┬─────────┘
           │          │            │            │
┌──────────▼──┐ ┌─────▼─────┐ ┌───▼────┐ ┌────▼────────┐
│   MySQL DB  │ │Cloudflare │ │Firebase│ │ UMS Portal  │
│  (Railway)  │ │    R2     │ │  FCM   │ │ ASU/EGY     │
│  Prisma ORM │ │  Storage  │ │ Push   │ │  Scraper    │
└─────────────┘ └───────────┘ └────────┘ └─────────────┘
```

### Authentication Flow

```
App Start
   │
   ├── Check /auth/user-role?email=...
   │
   ├── Role = STUDENT  ──► POST /ums/login (HTTP scrape)
   │                            │
   │                            └── If blocked ──► Puppeteer fallback
   │
   └── Role = PROFESSOR/ADMIN ──► POST /auth/login (JWT)
                                         │
                                         └── Token stored → FCM registered → Dashboard
```

---

## Tech Stack

### Frontend
| Technology | Purpose |
|---|---|
| Flutter 3.x | Cross-platform UI (Android, iOS, Web) |
| Flutter Riverpod 2.x | State management and dependency injection |
| GoRouter | Declarative navigation with auth route guards |
| Table Calendar | Schedule and academic event visualization |
| Firebase Messaging | Push notification reception |
| Flutter Local Notifications | Foreground notification display |
| Flutter Secure Storage | Encrypted JWT token persistence |
| File Picker / Image Picker | Assignment and profile photo uploads |
| Video Player | In-app lecture video playback |
| Cached Network Image | Optimized remote image loading |

### Backend
| Technology | Purpose |
|---|---|
| Node.js 18+ | Runtime environment |
| Express.js | REST API framework |
| Prisma ORM | Type-safe MySQL schema and querying |
| jsonwebtoken | JWT generation and validation |
| bcryptjs | Password hashing |
| Multer | File upload handling (50 MB limit) |
| Firebase Admin SDK | Server-side FCM push notification dispatch |
| Nodemailer | Email delivery (verification, password reset) |
| Puppeteer Core | Headless Chrome for UMS portal scraping |
| Cheerio | HTML parsing for UMS data extraction |
| Axios + Tough Cookie | HTTP client with session cookie management |
| AWS SDK (S3) | Cloudflare R2 file operations |
| Helmet | HTTP security headers |
| Express Rate Limit | API abuse prevention |
| Winston + Morgan | Structured logging |

### Database & Infrastructure
| Technology | Purpose |
|---|---|
| MySQL 8.0 | Relational database |
| Prisma Migrate | Schema versioning and migrations |
| Railway | Cloud hosting for API and MySQL |
| Cloudflare R2 | S3-compatible file storage |
| Firebase (ezway-c90e3) | Push notification infrastructure |
| Gmail SMTP | Email notifications |

---

## Implementation Overview

EZway was built in iterative phases, moving from data model and authentication outward to features, integrations, and deployment. The sections below describe how each major layer was developed.

---

### Phase 1 — Schema Design & Database Foundation

Development started with the Prisma schema before writing a single route. The full academic hierarchy was modeled first:

```
Faculty → Department → Program → Course
User → Enrollment → CourseInstructor
Task → TaskSubmission
CourseContent · CourseSchedule · Announcement · Notification · Note · ScheduleEvent
UmsSession · UmsCourse · UmsGrade
```

Key decisions made at this stage:
- `User.role` as a three-value enum (`STUDENT / PROFESSOR / ADMIN`) drives all access control downstream
- `Task` was made a single model covering assignments, exams, quizzes, labs, and personal tasks via a `taskType` field — avoiding separate tables with duplicated columns
- `TaskSubmission` has a composite unique key on `(taskId, studentId)` — one submission record per student per task, updated in place as the student progresses through `PENDING → SUBMITTED → GRADED`
- `Notification` stores both the in-app record and the FCM push state (`isPushed`) in the same row, keeping notification history and delivery status together
- Three UMS models (`UmsSession`, `UmsCourse`, `UmsGrade`) are kept separate from the core models so scraped data never pollutes the canonical enrollment and grade tables

Schema was pushed to Railway MySQL using `prisma db push` during development and promoted to `prisma migrate deploy` for production.

---

### Phase 2 — Authentication System

Two parallel authentication paths were implemented from the start because the user base is split:

**Local auth (professors and admins)**
- `POST /auth/register` → bcryptjs hash → user record → `VerificationCode` email sent via Nodemailer
- `POST /auth/verify` → mark `isVerified: true`
- `POST /auth/login` → compare hash → sign JWT (7-day, HS256) → return token

**UMS auth (students)**
- `GET /auth/user-role?email=` is called first by the Flutter app to determine which login path to use — this avoids the app ever needing to know in advance whether a credential belongs to a student or a professor
- `POST /ums/login` runs the scraping pipeline: HTTP fast path (CookieJar + CSRF extraction + form POST) with Puppeteer headless Chrome as a fallback
- On success, the student's profile, courses, and grades are synced into the local DB and a JWT is issued using the same format as local auth — the Flutter app handles both token types identically

**RBAC middleware** (`src/middleware/auth.js`) was written as composable functions:
- `authenticate` — verifies JWT, loads user, attaches to `req.user`
- `requireRole(...roles)` — checks `req.user.role` against an allowed list
- `optionalAuth` — attaches user if token present, continues without error if absent (used for public routes that optionally personalize)

---

### Phase 3 — REST API Route Modules

Routes were built module by module, each in its own file under `src/routes/`. Every route file follows the same pattern:

```
router.METHOD('/path', authenticate, requireRole('ROLE'), validate([...rules]), handler)
```

The controller logic lives inline in the route handlers rather than separate controller files — kept intentionally flat since the codebase is single-service. `express-validator` chains are defined at the route level and checked by the shared `validate` middleware before the handler runs.

Routes were built in this order, driven by what the Flutter app needed first:

| Order | Module | Why first |
|---|---|---|
| 1 | `/auth` | Nothing else works without tokens |
| 2 | `/courses` | Core entity — everything else references a course |
| 3 | `/users` | Profile data needed by the dashboard |
| 4 | `/tasks` | Highest student-facing value |
| 5 | `/content` | Professor content delivery |
| 6 | `/announcements` | Linked to notification dispatch |
| 7 | `/notifications` | Required for FCM wiring |
| 8 | `/schedule` | Calendar and event display |
| 9 | `/upload` + `/files` | Needed for assignment submissions and content |
| 10 | `/ums` | Student portal sync |
| 11 | `/notes` | Lower priority personal feature |
| 12 | `/admin` | Last — admin panel built after student/prof flows were stable |
| 13 | `/doctor-courses` | Convenience wrapper for professor dashboard |
| 14 | `/schedule-import` | Final integration — PDF pipeline |

---

### Phase 4 — Notification Pipeline

Notifications were wired in two layers so that neither layer depends on the other succeeding:

**Layer 1 — Database record**
Every action that warrants a notification (new announcement, assignment created, grade posted) calls `createNotification()` in `notification.service.js`. This writes a row to the `Notification` table with `isPushed: false` regardless of whether FCM succeeds.

**Layer 2 — FCM push**
After the DB write, `sendPushNotification()` is called. It reads the target user's `fcmToken` from the `User` record, calls the Firebase Admin SDK, and updates `isPushed: true` + `readAt` on success. If FCM fails (invalid token, network error), the DB record still exists and the user sees it in the in-app notification list on next open.

FCM token lifecycle:
- Token is obtained by the Flutter app after `firebase_messaging.getToken()`
- Sent to the backend via `POST /users/update-fcm-token` immediately after login
- A `onTokenRefresh` listener in the Flutter app re-sends the token whenever Firebase rotates it
- The backend overwrites `User.fcmToken` — always one active token per user

---

### Phase 5 — File Storage

File handling went through two implementations:

**First implementation — local disk**
`multer({ dest: 'uploads/' })` was used initially. Files were saved to the Railway filesystem and served via Express static middleware. This worked in development but breaks on Railway between deploys because the filesystem is ephemeral.

**Second implementation — Cloudflare R2**
Switched to `multer({ storage: multer.memoryStorage() })` — files stay in memory (50 MB cap). The upload handler calls `@aws-sdk/client-s3` with `PutObjectCommand`, using a UUID-based key so filenames never collide. The local disk path remains as a fallback: if `R2_ACCESS_KEY_ID` is absent from env, the file is written to `backend/uploads/` instead.

Files are never served by direct public R2 URL. Every file goes through `GET /files/:fileId`, which calls `GetObjectCommand` and streams the response — this keeps all files behind authentication and lets the app control access per role.

---

### Phase 6 — UMS Portal Integration

The UMS integration was the most technically complex part of the backend. The portal (`ums.asu.edu.eg`) has no public API, so the backend scrapes it.

**HTTP path (primary)**
1. `GET /App/Login_Form` with `axios` + `axios-cookiejar-support` + `tough-cookie` to capture the session cookie and extract the `__RequestVerificationToken` CSRF hidden field via Cheerio
2. `POST /App/Login_Form` with credentials + CSRF token as `application/x-www-form-urlencoded`
3. Check the final URL — if still on `Login_Form`, credentials are wrong; otherwise cookies are valid

**Puppeteer path (fallback)**
When the HTTP path times out or gets blocked, a headless Chrome instance is launched via `puppeteer-core`. The Chrome binary is located by checking: `CHROMIUM_PATH` env var → Railway nix profile paths → nix store search → standard Linux paths. The browser automates the login form including the Kendo DropDownList for domain selection (which requires jQuery evaluation inside `page.evaluate`).

**Profile extraction cascade**
The portal renders profile data differently depending on login state, browser, and page. Four strategies are tried in order, merging any non-null fields found: Kendo JSON endpoint → HTTP Cheerio (5 DOM layout strategies) → landing page HTML → Puppeteer full render.

**Data sync**
After scraping, `syncStudentData` runs:
- Each course is upserted into `UmsCourse`, then matched to an `App Course` by code, by name, or by creating a stub
- An `Enrollment` record is upserted linking the student to the matched course
- Each grade is upserted into `UmsGrade`
- Session cookies are stored in `UmsSession` for background re-sync without re-logging in

---

### Phase 7 — Schedule PDF Import

The schedule import pipeline bridges the Node.js backend and a Python PDF parser:

1. Admin uploads a PDF via the admin panel or Flutter admin screen
2. `POST /api/admin/schedule-import` receives the file via Multer and saves it to a temp path
3. `importScheduleFromPdf` calls `child_process.spawn` to run `python/scrape_schedule.py` with the PDF path and semester arguments
4. The Python script extracts schedule tables from each page, groups them by the program/department header found above each table, and outputs structured JSON to stdout
5. Node.js reads stdout, parses the JSON, then for each entry: validates the day and time fields, upserts the Course record (using a code-prefix → program name mapping table), deletes the old `CourseSchedule` rows for that course, and creates fresh rows
6. After all entries are processed, `relinkEnrollments` scans every `UmsCourse` row and retroactively enrolls any student whose portal course code matches one of the just-imported codes — this handles students who logged in before the PDF was uploaded

---

### Phase 8 — Flutter App Architecture

The Flutter app was structured around three principles:

**Single data layer**
`DataService` (`lib/services/data_service.dart`) is the only class that makes HTTP calls. Every screen reads data through Riverpod providers that call `DataService` methods — no screen imports `http` directly. This made it straightforward to change the base URL or add auth headers in one place.

**Riverpod for all state**
State was not managed with `setState` except for trivial local UI state (a text field, an animation). Every piece of server-derived data lives in a Riverpod `AsyncNotifierProvider` or `FutureProvider`. When a mutation happens (submit assignment, post announcement), the relevant provider is `ref.invalidate()`-d and the UI rebuilds automatically from fresh server data.

**Phase-based routing**
GoRouter uses a `redirect` callback that reads `authStateProvider`. The app has three phases:
- `AuthUnauthenticated` → `/welcome` → `/login`
- `AuthOnboardingRequired` → `/course-selection`
- `AuthAuthenticated` → role-specific dashboard (`/home`, `/doctor`, `/admin`)

This means no screen needs to check auth state itself — the router handles all redirects centrally.

**Role-aware dashboard shell**
`adaptive_dashboard.dart` reads the user's role from `currentUserProvider` and renders a different `NavigationBar` and shell for each role. Student, professor, and guest dashboards share the same shell widget but receive different navigation items and home screens.

---

### Phase 9 — Admin Panel

The admin panel is a standalone HTML5 single-page application served at `GET /admin` by Express static middleware from `backend/admin/index.html`. It uses no framework — plain JavaScript with `fetch()` for API calls and the admin JWT stored in `localStorage`.

The panel was built last, after all admin API routes were stable. It covers:
- System statistics (counts, 7-day signup trend)
- User table with search, role filter, and activate/deactivate toggle
- Course table with enrollment counts and professor assignment
- Department and program listing
- Schedule PDF upload form with import report display

The color scheme (dark blue `#002147` + gold `#FDC800`) mirrors the Faculty of Science branding.

---

### Phase 10 — Production Deployment

**Backend**
The backend is deployed to Railway as a Node.js service. Railway auto-provisions a MySQL 8 instance and injects `DATABASE_URL` into the environment. The `Procfile`-equivalent is the `start` script in `package.json`: `node src/index.js`. All secrets (JWT key, Firebase credentials, R2 keys, SMTP password) are set as Railway environment variables — never committed to the repo.

**Chromium on Railway**
Puppeteer requires a Chromium binary. Railway's nixpacks build system was configured to install Chromium via nix. The `getChromePath()` function in `ums.service.js` searches nix profile paths at runtime rather than hard-coding a path, making it portable across Railway plan changes.

**Flutter**
The production API URL (`https://ezway-production.up.railway.app/api`) is hard-coded in `lib/core/api_config.dart` as the default. Developers can override it at build time with `--dart-define=API_BASE_URL=http://localhost:3000/api` without changing source files.

**Firebase**
The Firebase project (`ezway-c90e3`) was configured with Android and iOS apps. The `google-services.json` and `GoogleService-Info.plist` files are included in the repo. Firebase initialization in the Flutter app is wrapped in a try/catch so a missing or misconfigured file does not crash the app — features that depend on FCM degrade gracefully.

---

## Database Schema

The system uses **17 Prisma-managed models** covering the full academic lifecycle:

```
Faculty
  └── Department
        └── Program
              └── Course
                    ├── CourseInstructor (→ User/Professor)
                    ├── Enrollment (→ User/Student)
                    ├── CourseContent (lectures, materials, videos)
                    ├── CourseSchedule (weekly class times)
                    ├── Task (assignments, exams, quizzes)
                    │     └── TaskSubmission (→ User/Student)
                    └── Announcement

User
  ├── VerificationCode (email verification tokens)
  ├── Notification (in-app + push)
  ├── Note (private notes)
  └── ScheduleEvent (personal calendar)

UMS Integration
  ├── UmsSession (portal login cookies)
  ├── UmsCourse (synced course list)
  └── UmsGrade (synced grade records)
```

### Key Model: User
```prisma
model User {
  id                   String   @id @default(uuid())
  email                String   @unique
  password             String?
  name                 String
  nameAr               String?
  role                 Role     @default(STUDENT)  // STUDENT | PROFESSOR | ADMIN
  studentId            String?
  level                Int?
  programId            String?
  departmentId         String?
  isVerified           Boolean  @default(false)
  isOnboardingComplete Boolean  @default(false)
  isActive             Boolean  @default(true)
  fcmToken             String?
  lastLoginAt          DateTime?
  // ... relations
}
```

### Key Model: Task (Assignments & Exams)
```prisma
model Task {
  id          String    @id @default(uuid())
  courseId    String
  title       String
  taskType    TaskType  // ASSIGNMENT | EXAM | QUIZ | PROJECT | LAB | PERSONAL
  priority    Priority  // LOW | MEDIUM | HIGH | URGENT
  dueDate     DateTime
  startDate   DateTime?
  maxPoints   Int       @default(100)
  attachments Json?
  questions   Json?     // Structured exam questions
  settings    Json?     // Exam timer, attempts, etc.
  published   Boolean   @default(false)
  submissions TaskSubmission[]
}
```

---

## API Reference

**Base URL:** `https://ezway-production.up.railway.app/api`

All authenticated endpoints require: `Authorization: Bearer <token>`

### Authentication
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/auth/register` | None | Register new account |
| `POST` | `/auth/login` | None | Login (professors/admins) |
| `POST` | `/auth/verify` | None | Verify email with code |
| `POST` | `/auth/forgot-password` | None | Request password reset |
| `GET` | `/auth/user-role?email=` | None | Check role for routing |
| `GET` | `/auth/me` | Required | Get current user profile |

### Courses
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/courses` | Required | List all courses |
| `GET` | `/courses/enrolled` | Student | Get enrolled courses |
| `POST` | `/courses/:id/enroll` | Student | Enroll in a course |
| `GET` | `/courses/:id` | Required | Course detail |
| `GET` | `/doctor-courses` | Professor | Get professor's courses |

### Tasks (Assignments & Exams)
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/tasks` | Required | List tasks (filter by course/type) |
| `POST` | `/tasks/create` | Professor | Create assignment or exam |
| `POST` | `/tasks/submit` | Student | Submit assignment/exam |
| `GET` | `/tasks/:id/submissions` | Professor | View all submissions |
| `POST` | `/tasks/grade` | Professor | Grade a submission |
| `GET` | `/tasks/professor-ungraded-counts` | Professor | Ungraded badge counts |

### Content
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/content` | Required | Get course content |
| `POST` | `/content/create` | Professor | Upload lecture/material |
| `GET` | `/content/professor` | Professor | Professor's uploaded content |

### Notifications
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/notifications` | Required | Get user notifications |
| `GET` | `/notifications/unread-count` | Required | Unread badge count |
| `POST` | `/notifications/mark-as-read` | Required | Mark notification read |

### Announcements
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/announcements` | Required | Get course/general announcements |
| `POST` | `/announcements` | Professor | Post new announcement |

### Schedule
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/schedule/upcoming` | Required | Upcoming events (7 days) |
| `GET` | `/schedule/my-events` | Required | Personal calendar events |
| `GET` | `/schedule/professor-schedule` | Professor | Professor's weekly schedule |

### File Operations
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/upload` | Required | Upload file to R2 (50MB max) |
| `GET` | `/files/:fileId` | Required | Download file via proxy |

### UMS Integration
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/ums/login` | None | Login via university portal |
| `POST` | `/ums/sync-courses` | Student | Sync courses from portal |
| `POST` | `/ums/sync-grades` | Student | Sync grades from portal |

### Admin
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/admin/stats` | Admin | System-wide statistics |
| `GET` | `/admin/users` | Admin | List users with filters |
| `GET` | `/admin/courses` | Admin | All courses with enrollment counts |
| `GET` | `/admin/departments` | Admin | Department list |
| `GET` | `/admin/programs` | Admin | Program list |
| `POST` | `/admin/schedule-import` | Admin | Upload PDF for schedule parsing |

---

## User Roles & Workflows

### Student Workflow
```
Login (UMS credentials)
  └── Auto-sync: courses, grades, profile from university portal
        └── Onboarding: select additional enrolled courses
              └── Dashboard
                    ├── Browse enrolled courses
                    ├── View lectures and materials
                    ├── Submit assignments (file upload)
                    ├── Take timed exams
                    ├── View grades and feedback
                    ├── Check weekly class schedule
                    ├── Read announcements
                    └── Receive push notifications
```

### Professor Workflow
```
Login (local credentials)
  └── Professor Dashboard
        ├── View assigned courses and enrollment counts
        ├── Upload course content (lectures, videos, docs)
        ├── Post announcements → system notifies students
        ├── Create assignments with due dates and rubrics
        ├── Build structured exams with question banks
        ├── Grade submissions → students receive notifications
        └── Track ungraded work via badge count
```

### Admin Workflow
```
Web Admin Panel (/admin)
  ├── View statistics: users, courses, enrollments, signups
  ├── Search, filter, and manage all user accounts
  ├── Activate / deactivate accounts
  ├── Assign professors to courses
  ├── Manage departments and programs
  └── Upload schedule PDFs → bulk update course times
```

---

## Getting Started

### Prerequisites
- Node.js 18+
- Flutter 3.x SDK
- MySQL 8.0 (or use Railway)
- Git

### Backend Setup

```bash
cd backend
npm install

# Copy and configure environment variables
cp .env.example .env
# Edit .env with your database, JWT, Firebase, and R2 credentials

# Generate Prisma client and push schema
npm run prisma:generate
npm run prisma:push

# Seed with test data (faculty, departments, courses, users)
npm run prisma:seed

# Start development server
npm run dev
# Server runs at http://localhost:3000
```

### Frontend Setup

```bash
# From project root
flutter pub get

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Run on web
flutter run -d chrome

# Run with local API instead of production
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
```

### Admin Panel

After starting the backend, open: `http://localhost:3000/admin`

---

## Environment Variables

Create `backend/.env` with the following:

```env
# Database
DATABASE_URL=mysql://user:password@host:port/database

# JWT
JWT_SECRET=your-secret-key-here
JWT_EXPIRES_IN=7d

# Server
PORT=3000
NODE_ENV=development

# Email (Gmail SMTP)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

# Firebase (FCM Push Notifications)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\n..."
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxx@your-project.iam.gserviceaccount.com

# Cloudflare R2 (File Storage)
R2_ACCESS_KEY_ID=your-access-key
R2_SECRET_ACCESS_KEY=your-secret-key
R2_ENDPOINT=https://your-account-id.r2.cloudflarestorage.com
R2_BUCKET_NAME=your-bucket-name

# Admin Seed Account
ADMIN_EMAIL=admin@college.edu
ADMIN_PASSWORD=admin123
```

---

## Deployment

### Backend on Railway

1. Connect your GitHub repository to Railway
2. Set all environment variables in the Railway dashboard
3. Railway auto-detects Node.js and runs `npm run start`
4. Add a MySQL plugin — Railway provides `DATABASE_URL` automatically
5. Deploy — the service runs at `https://your-app.up.railway.app`

### Database Migrations on Deploy

```bash
npx prisma migrate deploy
```

### Flutter Production Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires Mac + Xcode)
flutter build ios --release

# Web
flutter build web --release
```

---

## Test Accounts (After Seeding)

| Role | Email | Password | Notes |
|---|---|---|---|
| Admin | admin@college.edu | admin123 | Full system access |
| Professor | dr.ahmed@college.edu | professor123 | Math Dept — teaches CS101, CS201, STAT201 |
| Professor | dr.sara@college.edu | professor123 | Biology Dept — teaches Zoology, Microbiology |

> Students can also log in using real UMS/ASU portal credentials.

---

## Project Structure

```
Ezway/
├── lib/                          # Flutter application source
│   ├── core/
│   │   └── api_config.dart       # Base URL and auth headers
│   ├── models/                   # Data models (User, Course, Task, etc.)
│   ├── providers/                # Riverpod state providers
│   ├── screens/                  # All UI screens
│   │   ├── auth/                 # Login, Register, Verification
│   │   ├── doctor/               # Professor dashboard screens
│   │   ├── features/admin/       # Admin panel screens
│   │   ├── student_guide/        # 30+ program/course guide screens
│   │   └── TaskPages/            # Task creation and management
│   └── services/
│       └── data_service.dart     # Unified API interaction layer
│
├── backend/                      # Node.js/Express API
│   ├── src/
│   │   ├── routes/               # 14 route modules
│   │   ├── middleware/           # Auth, validation, error handling
│   │   ├── services/             # FCM, email, UMS scraping
│   │   └── utils/                # Database client, logger
│   ├── prisma/
│   │   ├── schema.prisma         # 17-model database schema
│   │   └── seed.js               # Database seeding script
│   └── admin/
│       └── index.html            # Admin web panel
│
├── assets/                       # Static assets and mock data
├── android/                      # Android native configuration
├── ios/                          # iOS native configuration
├── courses.json                  # Real Egyptian university course data
└── pubspec.yaml                  # Flutter dependencies
```

---

## Key Technical Decisions

**Why Flutter?**
Single codebase targeting Android, iOS, and Web — essential for a student project with limited resources and a broad user base.

**Why Riverpod?**
Compile-safe, testable state management. Providers automatically invalidate and refresh when data changes, ensuring the UI always reflects the latest server state.

**Why Prisma?**
Type-safe database access with auto-generated types matching the schema. Schema migrations are version-controlled and reproducible across environments.

**Why Cloudflare R2?**
S3-compatible API with no egress fees. Files are served through a backend proxy (`/files/*`) to prevent unauthorized direct access.

**Why UMS scraping?**
The university portal has no public API. HTTP-first scraping (2–5 seconds) with Puppeteer as a fallback (30–60 seconds) provides reliable data extraction while remaining resilient to portal changes.

---

## Challenges & Solutions

| Challenge | Solution |
|---|---|
| UMS portal blocks automated requests | HTTP-first with Puppeteer headless Chrome fallback |
| FCM tokens go stale after reinstall | Token refresh listener re-registers on every login |
| File upload byte handling on Android | Fixed `MultipartFile.fromBytes()` with correct content-type |
| Grading dashboard showing all students | Fixed Riverpod provider scoping — filtered by `courseId` |
| Dark mode breaking hardcoded colors | Replaced all hardcoded colors with `Theme.of(context)` tokens |
| Exam deadline validation too strict | Adjusted server-side validation with clear client feedback |
| State not refreshing after actions | Used Riverpod `ref.invalidate()` for automatic provider refresh |

---

## Future Work

- Real-time student-professor chat (WebSocket)
- Video call integration for online office hours
- Full Arabic RTL language support
- Offline mode with cached course content
- AI-powered academic advisor chatbot
- QR code-based attendance tracking
- Automated plagiarism detection for assignments
- Google Play Store and App Store release pipeline
- Redis caching layer for high-load scenarios
- Expand UMS integration to additional Egyptian universities

---

## Team

| Name | Role |
|---|---|
| [Team Member 1] | [Frontend / Backend / Full-stack] |
| [Team Member 2] | [Frontend / Backend / Full-stack] |
| [Team Member 3] | [Frontend / Backend / Full-stack] |
| [Team Member 4] | [Frontend / Backend / Full-stack] |

**Supervisor:** Dr. [Supervisor Name]

**Faculty of Science — [Department] — [University Name]**
**Academic Year: 2025–2026**

---

## License

This project was developed as a graduation project for the Faculty of Science. All rights reserved by the project team and their institution.

---

<div align="center">
Built with Flutter, Node.js, MySQL, Firebase, and Railway
</div>
