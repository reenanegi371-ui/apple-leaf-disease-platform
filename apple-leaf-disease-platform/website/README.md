# Apple Leaf Disease Platform - Website Workflow

Welcome to the web frontend of the Apple Leaf Disease Platform! This application is built using **Flask**, a lightweight Python web framework, to provide a fast, responsive, and user-friendly interface for disease detection.

## 📂 Project Structure & File Explanations

Here is a breakdown of every file and folder in the `website` directory and what they do:

### Core Python Files

*   **`requirements.txt`**: This file lists all the third-party Python libraries needed to run the website. 
    *   *Flask & Werkzeug*: The core components for routing and the web server.
    *   *requests*: Used to communicate with the FastAPI backend to send images for prediction.
    *   *Pillow*: Provides image processing capabilities if we need to resize or validate images before sending them.
    *   *python-dotenv*: Loads environment variables securely from a `.env` file.
    *   *Flask-WTF / WTForms*: Used for secure form submissions and CSRF protection.
*   **`app.py`**: The heart of the web application. It initializes the Flask app, defines all the routes (like `/`, `/detect`, `/results`), handles user image uploads, forwards them to the backend API, and renders the appropriate HTML pages with the API's response.
*   **`config.py`**: A centralized place for application configuration. This is where we store variables like `SECRET_KEY`, the max upload size (`MAX_CONTENT_LENGTH`), the `BACKEND_API_URL`, and paths to the upload directories. Keeping these separate ensures `app.py` stays clean.
*   **`run.py`**: A simple entry point script. Running `python run.py` will start the Flask development server on your local machine using the configurations defined.

### Frontend Directories

*   **`templates/`**: Contains all the HTML files (Jinja2 templates) that users see.
    *   `base.html`: The master template containing the navigation bar, footer, and basic HTML structure. All other pages inherit from this.
    *   `index.html`: The home/landing page.
    *   `detect.html`: The page containing the form where users upload leaf images.
    *   `results.html`: The page that displays the AI prediction (disease name, confidence, and treatments).
    *   `about.html` / `contact.html`: Static informational pages.
    *   `404.html`: A custom error page shown if a user navigates to a broken link.
*   **`static/`**: Contains static assets served directly to the browser.
    *   `css/`: Stylesheets (`style.css`) to make the app look beautiful and responsive.
    *   `js/`: Custom JavaScript files for client-side functionality (like previewing images before uploading).
    *   `images/`: Static image assets like logos or background banners.
    *   `uploads/`: A temporary directory where user-uploaded images are saved before being sent to the API.

---

## 🌟 The "Best & Unique" New Way: Modernizing Dependencies

While a standard `requirements.txt` is great, modern Python projects are moving towards **Dependency Management Tools** to guarantee that the app works the exact same way on every machine forever. 

### Proposal: Transition to `Poetry` or `uv`

Instead of just `requirements.txt`, using a modern tool like **Poetry** or **uv** is the "best" new way to handle Python workflows:

1.  **Deterministic Builds (Lockfiles)**: Tools like Poetry generate a `poetry.lock` file. This locks down *every single sub-dependency* to an exact hash and version. `requirements.txt` only locks your top-level packages, which can sometimes cause site-breaking bugs if a sub-package updates unexpectedly.
2.  **Built-in Virtual Environments**: Poetry automatically creates and manages isolated virtual environments so you don't clutter your system Python.
3.  **Cleaner Configuration**: All configurations, dependencies, and project metadata live inside a single, clean `pyproject.toml` file.

**How to migrate (Example using Poetry):**
1. Install Poetry: `pip install poetry`
2. Initialize in the website directory: `poetry init`
3. Add existing dependencies: `poetry add flask requests pillow python-dotenv flask-cors flask-wtf`
4. Run the app: `poetry run python run.py`

This ensures a robust, production-ready environment that is completely unique, fast, and fail-proof!

---

## 🚀 Quick Start Guide

If you prefer the standard way using the existing files, follow these steps:

1.  Open your terminal and navigate to the `website` directory:
    ```bash
    cd path/to/project_apple/apple-leaf-disease-platform/website
    ```
2.  Create and activate a virtual environment (optional but highly recommended):
    ```bash
    python -m venv venv
    # On Windows:
    venv\Scripts\activate
    ```
3.  Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```
4.  Ensure the FastAPI backend is running! The website acts as a bridge and needs the AI model to function.
5.  Start the Flask server:
    ```bash
    python run.py
    ```
6.  Open your browser and visit `http://127.0.0.1:5000/` completely interact with the platform.
