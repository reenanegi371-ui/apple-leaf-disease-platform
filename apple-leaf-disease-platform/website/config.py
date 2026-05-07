import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Base Directory
BASE_DIR = Path(__file__).resolve().parent

# --- VERCEL SPECIFIC PATHS ---
# Vercel only allows writing to the /tmp folder
if os.environ.get('VERCEL'):
    DATABASE_PATH = '/tmp/detections.db'
    UPLOAD_FOLDER = '/tmp/uploads'
    LOG_FILE = '/tmp/website.log'
else:
    DATABASE_PATH = os.path.join(BASE_DIR, 'detections.db')
    UPLOAD_FOLDER = os.path.join(BASE_DIR, 'static', 'uploads')
    LOG_FILE = os.path.join(BASE_DIR, 'logs', 'website.log')

# Create directories if they don't exist (only if not on Vercel)
if not os.environ.get('VERCEL'):
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)

# Flask Configuration
FLASK_CONFIG = {
    'SECRET_KEY': os.getenv('SECRET_KEY', 'your-secret-key-change-this-in-production'),
    'DEBUG': os.getenv('DEBUG', 'True').lower() == 'true',
    'HOST': os.getenv('HOST', '0.0.0.0'),
    'PORT': int(os.getenv('PORT', 5000))
}

# Upload Configuration
UPLOAD_CONFIG = {
    'folder': UPLOAD_FOLDER,
    'max_size': 16 * 1024 * 1024,  # 16MB
    'allowed_extensions': {'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'tiff', 'tif'}
}

# Backend API Configuration
BACKEND_CONFIG = {
    'url': os.getenv('BACKEND_URL', 'http://127.0.0.1:8000'),
    'timeout': int(os.getenv('TIMEOUT', 30)),
    'endpoints': {
        'health': '/health',
        'detect': '/detect',
        'disease_info': '/disease-info',
        'all_diseases': '/all-diseases'
    }
}

# Database Configuration
DATABASE_CONFIG = {
    'uri': os.getenv('DATABASE_URL', f'sqlite:///{DATABASE_PATH}'),
    'track_modifications': False
}

# Disease Information
DISEASE_NAMES = ['Apple Scab', 'Black Rot', 'Cedar Apple Rust', 'Healthy']

# Logging Configuration
LOGGING_CONFIG = {
    'level': 'INFO',
    'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    'file': LOG_FILE
}
