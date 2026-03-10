"""
Entry point for Flask website
"""

from app import app
from config import FLASK_CONFIG

if __name__ == '__main__':
    app.run(
        host=FLASK_CONFIG['HOST'],
        port=FLASK_CONFIG['PORT'],
        debug=FLASK_CONFIG['DEBUG']
    )