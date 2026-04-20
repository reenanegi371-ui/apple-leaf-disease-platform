"""
Configuration file for FastAPI Backend
"""

import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Base Directory
BASE_DIR = Path(__file__).resolve().parent

# Model Configuration
MODEL_CONFIG = {
    'path': os.path.join(BASE_DIR, 'models', 'best.pt'),
    'input_size': 224,
    'class_names': ['Apple Scab', 'Black Rot', 'Cedar Apple Rust', 'Healthy'],
    'confidence_threshold': 0.5
}

# Server Configuration
SERVER_CONFIG = {
    'host': os.getenv('HOST', '127.0.0.1'),
    'port': int(os.getenv('PORT', 8000)),
    'debug': os.getenv('DEBUG', 'True').lower() == 'true',
    'reload': os.getenv('RELOAD', 'True').lower() == 'true',
    'mock_mode': os.getenv('MOCK_MODE', 'True').lower() == 'true'
}

# API Configuration
API_CONFIG = {
    'title': 'Apple Leaf Disease Detection API',
    'version': '1.0.0',
    'description': 'API for detecting diseases in apple leaves using deep learning'
}

# CORS Configuration
CORS_CONFIG = {
    'allow_origins': ['*'],
    'allow_credentials': True,
    'allow_methods': ['*'],
    'allow_headers': ['*']
}

# File Upload Configuration
UPLOAD_CONFIG = {
    'max_file_size': 10 * 1024 * 1024,  # 10MB
    'allowed_extensions': ['.jpg', '.jpeg', '.png', '.bmp'],
    'temp_dir': os.path.join(BASE_DIR, 'temp')
}

# Image Preprocessing Configuration
PREPROCESS_CONFIG = {
    'mean': [0.485, 0.456, 0.406],
    'std': [0.229, 0.224, 0.225],
    'normalize': True
}

# Logging Configuration
LOGGING_CONFIG = {
    'level': 'INFO',
    'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    'file': os.path.join(BASE_DIR, 'logs', 'app.log')
}

# Create necessary directories
os.makedirs(UPLOAD_CONFIG['temp_dir'], exist_ok=True)
os.makedirs(os.path.dirname(LOGGING_CONFIG['file']), exist_ok=True)