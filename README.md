# AI Experts Assignment (Python)

## 🎯 Project Aim

This project demonstrates production-style engineering practices:

- Reproducible environments using pinned dependencies
- Containerized test execution (CI-style)
- Focused bug identification
- Minimal, reviewable fix implementation
- Clear technical documentation

The goal was to identify and fix a bug in the HTTP client while keeping changes minimal and well-tested.

---

## ✅ What Was Done

- Added a reproducible `requirements.txt` with pinned dependencies
- Implemented a Dockerfile to run tests in a clean, isolated environment
- Identified and fixed a bug in OAuth2 token refresh logic
- Ensured all existing tests pass
- Preserved existing structure and avoided unnecessary refactoring
- Documented reasoning and tradeoffs in `Explanation.md`

The fix ensures expired OAuth2 tokens provided as dictionaries are properly refreshed before sending API requests.

---

## 🧪 How to Run and Test Locally

### 1. Create and activate a virtual python environment

**On Windows:**
- python -m venv venv
- venv\Scripts\activate

**On macOS / Linux**
- python -m venv venv
- source venv/bin/activate
### 2. Install dependencies
- pip install -r requirements.txt

### 3. Run the test suite
- pytest -v
## 🧪 How to Run and Test with Docker
### 1. Build the Docker image
- docker build -t ai-experts-assignment .
### 2. Run the container
- docker run --rm ai-experts-assignment

*NB:-* 
- The above command with the --rm flag will launches a new container from the ai-assignment image and automatically removes it upon exit. 
- The --rm flag is ideal for temporary tasks, testing, or one-time AI model runs, as it cleans up the container filesystem and prevents the accumulation of stopped containers. 
- The container runs the test suite by default using: `python -m pytest -v` and this ensures the tests execute in a clean, non-interactive, CI-style environment.

## 📄 Additional Notes

- The bug analysis and reasoning are documented in `Explanation.md`.
- Changes were intentionally kept minimal to ensure clarity and reviewability.