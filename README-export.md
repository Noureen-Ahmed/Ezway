# Antigravity Gemini Pro 🚀

Antigravity Gemini Pro is a powerful Python-based intelligent assistant project that leverages the capabilities of the Google Gemini Pro model combined with the `antigravity` framework. It is designed to provide seamless AI interactions, automate complex tasks, and act as a highly capable AI agent for your workflow.

---

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
It is highly recommended to use a virtual environment to keep dependencies isolated so they don't interfere with other Python projects.

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

### 4. Set Up Your Gemini API Key
This project requires a Google Gemini API key to function. You need to set it as an environment variable.

**For Windows (Command Prompt):**
```cmd
set GEMINI_API_KEY=your_api_key_here
```
**For Windows (PowerShell):**
```powershell
$env:GEMINI_API_KEY="your_api_key_here"
```

**For macOS and Linux:**
```bash
export GEMINI_API_KEY="your_api_key_here"
```
*(Note: To make this permanent, you can add the export command to your `.bashrc` or `.zshrc` file, or use a `.env` file if supported by the project).*

---

## 🚀 How to Run

Once everything is set up, you can start the project by running the following command from the root directory:

```bash
python main.py
```
*(If your main execution file has a different name, replace `main.py` with the correct filename).*

---

## 📂 Project Structure

Here is a brief overview of the main files and folders in this repository:

```text
antigravity-gemini-pro/
│
├── main.py              # The main entry point to run the application
├── requirements.txt     # List of required Python libraries
├── .gitignore           # Specifies files that Git should ignore (like the venv folder)
├── README.md            # Project documentation (this file)
└── src/                 # Folder containing the core code and modules
    ├── agent.py         # Logic for the Antigravity agent operations
    └── gemini_api.py    # Functions handling communication with the Gemini API
```

---

## 📦 Dependencies

The core libraries powering this project are:
- `google-generativeai`: The official SDK to interact with the Google Gemini AI models.
- `antigravity`: The agentic coding framework used to structure the AI's capabilities.
- *(Any other core libraries will be listed in `requirements.txt`)*

---

## 🛠️ Troubleshooting

Here are some common issues you might run into and how to fix them:

**1. Error: `ModuleNotFoundError: No module named 'google.generativeai'`**
- **Cause:** The dependencies were not installed properly, or the virtual environment is not activated.
- **Fix:** Make sure your virtual environment is activated `(venv)` and run `pip install -r requirements.txt` again.

**2. Error: `google.api_core.exceptions.PermissionDenied: API key not valid` or `API_KEY is missing`**
- **Cause:** The `GEMINI_API_KEY` environment variable is either not set or is incorrect.
- **Fix:** Double-check that you have entered the exact API key provided by Google AI Studio without any extra spaces, and ensure you ran the correct environment variable setup command for your operating system.

**3. Error: `python: command not found`**
- **Cause:** Python is not installed, or it is not added to your system's PATH.
- **Fix:** Download Python from python.org and install it. During installation, make sure to check the box that says "Add Python to PATH". On Mac/Linux, you may need to use `python3` instead of `python`.
