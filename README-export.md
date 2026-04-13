

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
