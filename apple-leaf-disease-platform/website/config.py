"""
Configuration file for Flask Website
"""

import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Base Directory
BASE_DIR = Path(__file__).resolve().parent

# Flask Configuration
FLASK_CONFIG = {
    'SECRET_KEY': os.getenv('SECRET_KEY', 'your-secret-key-change-this-in-production'),
    'DEBUG': os.getenv('DEBUG', 'True').lower() == 'true',
    'HOST': os.getenv('HOST', '0.0.0.0'),
    'PORT': int(os.getenv('PORT', 5000))
}

# Upload Configuration
UPLOAD_CONFIG = {
    'folder': os.path.join(BASE_DIR, 'static', 'uploads'),
    'max_size': 16 * 1024 * 1024,  # 16MB
    'allowed_extensions': {'png', 'jpg', 'jpeg', 'gif', 'bmp'}
}

# Backend API Configuration
BACKEND_CONFIG = {
    'url': os.getenv('BACKEND_URL', 'http://localhost:8000'),  # FastAPI backend URL
    'timeout': int(os.getenv('TIMEOUT', 30)),  # seconds
    'endpoints': {
        'health': '/health',
        'detect': '/detect',
        'disease_info': '/disease-info',
        'all_diseases': '/all-diseases'
    }
}

# Disease Information
DISEASE_NAMES = ['Apple Scab', 'Black Rot', 'Cedar Apple Rust', 'Healthy']

# Create upload directory if it doesn't exist
os.makedirs(UPLOAD_CONFIG['folder'], exist_ok=True)

# Logging Configuration
LOGGING_CONFIG = {
    'level': 'INFO',
    'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    'file': os.path.join(BASE_DIR, 'logs', 'website.log')
}

# Create logs directory
os.makedirs(os.path.dirname(LOGGING_CONFIG['file']), exist_ok=True)