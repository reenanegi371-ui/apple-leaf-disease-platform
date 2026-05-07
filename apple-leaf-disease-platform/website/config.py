# --- CHANGE THIS SECTION ---
# Use /tmp for database and uploads if running on Vercel
if os.environ.get('VERCEL'):
    DATABASE_PATH = '/tmp/detections.db'
    UPLOAD_FOLDER = '/tmp/uploads'
else:
    DATABASE_PATH = os.path.join(BASE_DIR, 'detections.db')
    UPLOAD_FOLDER = os.path.join(BASE_DIR, 'static', 'uploads')

# Update the configs
UPLOAD_CONFIG['folder'] = UPLOAD_FOLDER
DATABASE_CONFIG['uri'] = os.getenv('DATABASE_URL', f'sqlite:///{DATABASE_PATH}')
# ---------------------------
