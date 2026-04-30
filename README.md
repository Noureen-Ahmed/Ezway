# College Guide App

A comprehensive Flutter mobile application for Egyptian science faculty students and professors, with a production-ready Node.js backend.

## 📱 Overview

The College Guide app helps students and professors in Egyptian science faculties manage their academic activities including courses, assignments, schedules, and announcements.
## ENV FILE DONT FORGET  env.txt

## doctor test acc 
- **doctor@college.edu** 
- password : doctor123

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your machine:
- **Python:** Version 3.8 or higher
- **pip:** Python package manager (comes with Python)
- **Git** (optional, but recommended for cloning the repository)

---

## ⚙️ Installation Steps

Follow these step-by-step instructions to set up the project on your local machine (Windows, Mac, or Linux).

### 1. Clone the Repository
First, download the project files to your computer:
```bash
git clone https://github.com/yourusername/antigravity-gemini-pro.git
cd antigravity-gemini-pro
```

### 2. Create a Virtual Environment
It is highly recommended to use a virtual environment to keep dependencies isolated so they don't interfere with other Python projects.git 

**For Windows:**
```bash
python -m venv venv
venv\Scripts\activate
```

**For macOS and Linux:**
```bash
python3 -m venv venv
source venv/bin/activate
```
*(When activated, your terminal prompt should show `(venv)` at the beginning).*

### 3. Install Dependencies
With the virtual environment activated, install the required libraries:
```bash
pip install -r requirements.txt
```


## 🚀 How to Run

Once everything is set up, you can start the project by running the following command from the root directory:

```bash
python main.py
```
*(If your main execution file has a different name, replace `main.py` with the correct filename).*

---
open 2 terminal :
first one :
cd backend
npm run dev (for db)

second one :
flutter run -d chrome 
or ur phone

## 📂 Project Structure

Here is a brief overview of the main files and folders in this repository:

```text
Ezway/
│
├── backend/             # The main entry point to run the application
├── requirements.txt     # List of required Python libraries
├── .gitignore           # Specifies files that Git should ignore (like the venv folder)
├── README.md            # Project documentation (this file)
└── src/                 # Folder containing the core code and modules
    ├── agent.py         # Logic for the Antigravity agent operations
    └── gemini_api.py    # Functions handling communication with the Gemini API
```

---



## 🛠️ Troubleshooting

Here are some common issues you might run into and how to fix them:

**1. Error: `ModuleNotFoundError: No module named 'google.generativeai'`**
- **Cause:** The dependencies were not installed properly, or the virtual environment is not activated.
- **Fix:** Make sure your virtual environment is activated `(venv)` and run `pip install -r requirements.txt` again.


**3. Error: `python: command not found`**
- **Cause:** Python is not installed, or it is not added to your system's PATH.
- **Fix:** Download Python from python.org and install it. During installation, make sure to check the box that says "Add Python to PATH". On Mac/Linux, you may need to use `python3` instead of `python`.

### Faculty Structure
```
Faculty of Science
├── Mathematics Department
│   ├── Computer Science Program
│   ├── Statistics Program
│   └── Pure Mathematics Program
├── Biology Department
│   ├── Zoology Program
│   ├── Botany Program
│   └── Microbiology Program
├── Chemistry Department
│   ├── Applied Chemistry Program
│   └── Biochemistry Program
└── Physics Department
```

## 🚀 Quick Start

### Backend Setup
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your database credentials

npm run prisma:generate
npm run prisma:push
npm run prisma:seed

npm run dev
```

### Flutter App
```bash
flutter pub get
flutter run
```

## 🔐 Test Accounts

After running `npm run prisma:seed`:

| Role | Email | Password | Details |
|------|-------|----------|---------|
| **Admin** | admin@college.edu | admin123 | Full system access |
| **Professor** | dr.ahmed@college.edu | professor123 | Math Dept, teaches CS101/CS201/CS402/STAT201 |
| **Professor** | dr.mohamed@college.edu | professor123 | Math Dept, teaches CS301/MATH101 |
| **Professor** | dr.sara@college.edu | professor123 | Biology Dept, teaches Zoology/Microbiology |
| **Professor** | dr.khalid@college.edu | professor123 | Chemistry Dept |
| **Student** | student@college.edu | student123 | CS Program, Level 3, GPA 3.45 |
| **Student** | mona@college.edu | student123 | CS Program, Level 2, GPA 3.78 |
| **Student** | omar@college.edu | student123 | Statistics Program, Level 4, GPA 3.12 |

## 📱 Features

### For Students
- ✅ View enrolled courses and schedules  
- ✅ Track assignments, exams, and deadlines
- ✅ Receive push notifications for new content
- ✅ View announcements from professors
- ✅ Personal task management
- ✅ Calendar with course schedules

### For Professors
- ✅ View assigned courses and enrolled students
- ✅ Create lectures, assignments, and exams
- ✅ Post announcements (with push notifications)
- ✅ View students' program information

### Admin Panel (Web)
- ✅ Access at: `http://localhost:3000/admin/`
- ✅ Manage users (students, professors, admins)
- ✅ Manage courses and instructor assignments
- ✅ Filter professors by department
- ✅ Assign professors to programs
- ✅ View system statistics

## 🗄️ Database Schema

### Key Tables
- **Faculty** - Faculties (e.g., Science, Engineering)
- **Department** - Departments within faculties
- **Program** - Specializations within departments
- **User** - Students, Professors, Admins
- **Course** - Academic courses
- **Enrollment** - Student enrollments with grades
- **Task** - Assignments, exams, quizzes
- **TaskSubmission** - Student submissions
- **Announcement** - Course and general announcements
- **Notification** - Push and in-app notifications
- **CourseSchedule** - Weekly recurring class times

### Relationships
- Students belong to ONE program (specialization)
- Professors belong to ONE department
- Professors can teach in MULTIPLE programs
- Courses belong to departments (optionally to programs)

## 📁 Project Structure

```
├── backend/
│   ├── prisma/
│   │   ├── schema.prisma    # Complete database schema
│   │   └── seed.js          # Sample data seeder
│   ├── src/
│   │   ├── index.js         # Express server
│   │   ├── routes/          # API endpoints
│   │   ├── middleware/      # Auth, validation
│   │   ├── services/        # Email, notifications
│   │   └── utils/           # Database, logging
│   └── admin/               # Web admin panel
│
├── lib/
│   ├── core/                # Config, exceptions
│   ├── models/              # Data models
│   ├── providers/           # Riverpod state
│   ├── services/            # DataService (unified API)
│   ├── screens/             # UI screens
│   └── widgets/             # Reusable components
```

## 🔌 API Endpoints

### Authentication
```
POST /api/auth/register     - Register new user
POST /api/auth/login        - Login
POST /api/auth/verify       - Verify email
POST /api/auth/forgot-password - Request password reset
GET  /api/auth/me           - Get current user
```

### Courses
```
GET  /api/courses           - List all courses
GET  /api/courses/:id       - Course details
POST /api/courses/:id/enroll - Enroll in course
GET  /api/courses/professor/:email - Professor's courses
```

### Content (Professor Only)
```
POST /api/content           - Create lecture
POST /api/content/assignment - Create assignment
POST /api/content/exam      - Create exam
```

### Admin
```
GET  /api/admin/stats       - Dashboard statistics
GET  /api/admin/users       - List users (paginated)
GET  /api/admin/professors  - List professors (filter by dept)
PUT  /api/admin/professors/:id/department - Change department
POST /api/admin/professors/:id/programs - Assign to program
GET  /api/admin/departments - List departments
GET  /api/admin/programs    - List programs
GET  /api/admin/faculties   - List faculties
```

## 🛠️ Tech Stack

### Backend
- Node.js 18+ with Express.js
- MySQL with Prisma ORM
- JWT authentication
- Firebase Cloud Messaging (push notifications)
- Winston logging
- Helmet security

### Frontend
- Flutter 3.x
- Riverpod state management
- GoRouter navigation
- http package for API calls

## 📦 Environment Variables

Create `backend/.env`:
```env
# Database (Railway MySQL)
DATABASE_URL="mysql://root:RSpdobSgfKNlJUJgzWLgRdCgQieWtpDc@centerbeam.proxy.rlwy.net:22148/railway"

# MySQL Connection
DB_HOST=centerbeam.proxy.rlwy.net
DB_PORT=22148
DB_USER=root
DB_PASSWORD=RSpdobSgfKNlJUJgzWLgRdCgQieWtpDc
DB_NAME=railway

# Server
PORT=3000
NODE_ENV=development

# JWT
JWT_SECRET=college-guide-super-secret-key-change-in-production
JWT_EXPIRES_IN=7d

# Email (configure with your SMTP)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=noureenahmed1610@gmail.com
EMAIL_PASS=rgfhnowhxlnhknro


# Firebase Cloud Messaging (optional - for push notifications)
FIREBASE_PROJECT_ID=ezway-c90e3
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDWCAgp+jD5wtL8\nh2Z12EzYTUFaGD/nXfMJtKXxFbr3kUfkPoVXtGAvLJACsQGcJjVbTjdhP4gUVlYA\nkieqlw/Cxbgdo+xOCvRwrPLYgJwX0DWOk8flbTWANpkaScUrPDChPyf+KxrWNC48\nCSypYQ//d0Cuf8YHqptSdqCAyyM00OI4At41b6G2PzjgZopTp82mzXt1jacagkWi\nv/fYbVEd4BuPXIa2TQwSZ72bV+47HpfjGMnJxnAEpry+Ru774S7dJv2HlC5OIN0Z\nAlEWeP5xnhC9E+iwiag9BforM56Ju8u1k2kvPWE/QOtX0DW4v66Ds38ofU7DK+Bn\nC94MikGlAgMBAAECggEAAXiwQL0oCbAC0dqDJ/blwJWky9EI6+f1tYVm+k0u+SRz\nSVfdC9GjFS0esd4Kx9IhMMcf2mcY6ZuWObfHg58bIOXRJV99zqsx2NejT6bZhjnq\nmnYROHwConl2FqVTXalJXGtfpaGZlgPS0pua1VKvXAezS5SHPepPUobmqu/F4Ozb\n1vmioIzKWZqzVAW80bOFzXNFJfHfJTsR/GlOw6s3ozGIvBqw5a+g2Hr2OlAlnw6l\n2Y97/RP81VFf9FIW6bFu3Y4uBDa2T3ulw7bU6p8LCx1qanX0eNX2xPctYPsD38O+\nAwJYwQFQWNC0gVJzjefvVCjXp0ka0fglHwCdxF+QAQKBgQD1loPF7sf/OTW4dJpQ\nQZaNYMs6c9pNuYZd0J3pUBCSDuVhKmGFw3YV7a/C1cbZmDKg1gZr40P/RGnvQ3ag\nSQs4CPItKVtC3oZeXNY4jjDh8cLokPJEakVtrm2binafvRnJtk3O0HfQ7cIWExWY\nuAwY8CEf3xXlrCBYYopUbhW4AQKBgQDfGwSxh7VgyhSvuJUE7hgmkfhr/+azpSTK\nuGGX7e1XkO3VlrBFIjOfzSklpacLB0U4/grRn7vtbWG68+3FOLJz76MiZbrApPyI\nfUzGktUtief0/TZztqLWnRBlFsv8AAEJxoRr7iH1+7QgiY3QUg7g1ywBQ2Q9+6RB\nINBP0hKppQKBgB8DRtiz8qWUP+hvMR15at2nn4JeJu8xwnoOYiKYbb9ECkte4rnV\nmQ/j2BIulNHdmmcdH+p35JpTtVz1lAFht/z3hD2Xv2KOX0GDT7oMmretpANianWh\nRes337eIoLpDUwJZ9zFqufa0T5IiDtQeScjMaiJwNX+vYNZIe1d2H2ABAoGAWIER\nVZOuQh0oI6UniHMjJXnWgJFdZXpno/uMy4ZZFtmpX4eNmX8913C9l++k2l0h+r/c\nbtfc5wzzLgTCF/Cr6g3wOx77/Jv2ifaa1FM/OfdxCuDADxsucdCQxmlKtkcSIlyb\n/2zSEBCvnhCzLya+PDdff4jKZUREHonz2RZOzPkCgYEA7vDujlySBuE+Py1YlmZO\nRkA6jHarWBSpDGRbFQfwAtJ+QxcwPwRif0L3T3vU0OSnW20Mgsqxfbep1TxKpuW8\nVSdMXjsDlrI1X7p/D8NNlP/DlPeRQ5CFDbKuqrGri1a1Qeb5A4Ro1UQ2yWFEGg9M\n8D8yQsLQ+qIpMvp6I269K/A=\n-----END PRIVATE KEY-----\n"

FIREBASE_CLIENT_EMAIL=firebase-adminsdk-fbsvc@ezway-c90e3.iam.gserviceaccount.com


# Admin
ADMIN_EMAIL=admin@college.edu
ADMIN_PASSWORD=admin123

# Cloudflare R2
R2_ACCESS_KEY_ID=1dcc425bdbb88d4e1d0fac9557932825
R2_SECRET_ACCESS_KEY=043e118ee0e42c99a19ca53a7b9c501d4683ba9adbf49c194829ea8a185cd8ab
R2_ENDPOINT=https://dcbf47d19aec18cb569cbef0d81efa15.r2.cloudflarestorage.com
R2_PUBLIC_URL=https://pub-365eed07c3dc495abbd9f6b237bf5875.r2.dev
R2_BUCKET_NAME=college-guide

# EmailJS Config
EMAILJS_PUBLIC_KEY=KpiEHFZURo_yIgMCl
EMAILJS_PRIVATE_KEY=QPDQrEBeAEx8p9xSP88Xj

# Your Service and Template IDs
EMAILJS_SERVICE_ID=service_qro3d8f
EMAILJS_TEMPLATE_ID=template_ggz2ghg
```

## 🔔 Push Notifications

Automatic notifications are sent when professors:
- Add new lectures or content
- Create assignments (with due date)
- Schedule exams (with exam date)
- Post announcements to courses

## 📄 License

MIT License
