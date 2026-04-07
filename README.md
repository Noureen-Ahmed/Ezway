# College Guide App

A comprehensive Flutter mobile application for Egyptian science faculty students and professors, with a production-ready Node.js backend.

## 📱 Overview

The College Guide app helps students and professors in Egyptian science faculties manage their academic activities including courses, assignments, schedules, and announcements.


m

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
DATABASE_URL="mysql://user:pass@localhost:3306/college_guide"
PORT=3000
JWT_SECRET=your-super-secret-key
JWT_EXPIRES_IN=7d
EMAIL_HOST=smtp.gmail.com
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=app-password
FIREBASE_PROJECT_ID=your-project
```

## 🔔 Push Notifications

Automatic notifications are sent when professors:
- Add new lectures or content
- Create assignments (with due date)
- Schedule exams (with exam date)
- Post announcements to courses

## 📄 License

MIT License
