"""
Flask Website for Apple Leaf Disease Detection
"""

from flask import Flask, render_template, request, jsonify, send_file
import requests
import os
from werkzeug.utils import secure_filename
from datetime import datetime
import uuid
from PIL import Image
import io
import base64
import json
from config import FLASK_CONFIG, UPLOAD_CONFIG, BACKEND_CONFIG, DATABASE_CONFIG
from models import db, Detection

app = Flask(__name__)

# Configuration
app.config.update(FLASK_CONFIG)
app.config['UPLOAD_FOLDER'] = UPLOAD_CONFIG['folder']
app.config['MAX_CONTENT_LENGTH'] = UPLOAD_CONFIG['max_size']
app.config['ALLOWED_EXTENSIONS'] = UPLOAD_CONFIG['allowed_extensions']
app.config['BACKEND_URL'] = BACKEND_CONFIG['url']
app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_CONFIG['uri']
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = DATABASE_CONFIG['track_modifications']

# Initialize database
db.init_app(app)

# Create database tables
with app.app_context():
    db.create_all()

# Create upload folder if it doesn't exist
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

def allowed_file(filename):
    """Check if file extension is allowed"""
    if not filename:
        return False
    
    if '.' not in filename:
        return False
    
    ext = filename.rsplit('.', 1)[1].lower()
    return ext in app.config['ALLOWED_EXTENSIONS']

def call_backend_detection(image_path):
    """Call FastAPI backend for disease detection"""
    try:
        with open(image_path, 'rb') as f:
            files = {'file': f}
            response = requests.post(
                f"{app.config['BACKEND_URL']}/detect",
                files=files
            )
        
        if response.status_code == 200:
            return response.json()
        else:
            return {"error": f"Backend error: {response.status_code}"}
    
    except Exception as e:
        return {"error": f"Failed to call backend: {str(e)}"}

def get_disease_info(disease_name):
    """Get disease information from backend"""
    try:
        response = requests.get(
            f"{app.config['BACKEND_URL']}/disease-info/{disease_name}"
        )
        if response.status_code == 200:
            data = response.json()
            return data.get('info', {})
    except:
        pass
    return {}

@app.route('/')
def index():
    """Home page"""
    return render_template('index.html')

@app.route('/detect', methods=['GET', 'POST'])
def detect():
    """Detection page"""
    if request.method == 'POST':
        # Check if file was uploaded
        if 'image' not in request.files:
            return render_template('detect.html', error='No file uploaded')
        
        file = request.files['image']
        
        if file.filename == '':
            return render_template('detect.html', error='No file selected')
        
        if not allowed_file(file.filename):
            # Get file extension for better error message
            if '.' in file.filename:
                ext = file.filename.rsplit('.', 1)[1].lower()
                error_msg = f'File type .{ext} is not supported. Please upload PNG, JPG, JPEG, GIF, BMP, WebP, TIFF, or TIF files.'
            else:
                error_msg = 'File must have a valid extension. Please upload PNG, JPG, JPEG, GIF, BMP, WebP, TIFF, or TIF files.'
            return render_template('detect.html', error=error_msg)
        
        # Generate unique filename
        filename = secure_filename(file.filename)
        ext = filename.rsplit('.', 1)[1].lower()
        new_filename = f"{uuid.uuid4()}.{ext}"
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], new_filename)
        
        # Save file
        file.save(filepath)
        
        # Call backend for detection
        result = call_backend_detection(filepath)
        
        if 'error' in result:
            return render_template('detect.html', error=result['error'])
        
        # Get disease info
        disease_info = get_disease_info(result['disease'])
        
        # Save detection to database
        detection = Detection(
            filename=filename,
            image_path=f"uploads/{new_filename}",
            disease=result['disease'],
            confidence=result['confidence'],
            disease_info=json.dumps(disease_info)
        )
        db.session.add(detection)
        db.session.commit()
        
        # Prepare data for template
        detection_data = {
            'image_path': f"static/uploads/{new_filename}",
            'result': result,
            'disease_info': disease_info,
            'timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }
        
        return render_template('results.html', **detection_data)
        
        return render_template('detect.html', error='Invalid file type')
    
    return render_template('detect.html')

@app.route('/about')
def about():
    """About diseases page"""
    try:
        response = requests.get(f"{app.config['BACKEND_URL']}/all-diseases")
        if response.status_code == 200:
            diseases = response.json().get('diseases', {})
        else:
            diseases = {}
    except:
        diseases = {}
    
    return render_template('about.html', diseases=diseases)

@app.route('/contact')
def contact():
    """Contact page"""
    return render_template('contact.html')

@app.route('/history')
def history():
    """Detection history page"""
    # Get recent detections (last 50)
    detections = Detection.query.order_by(Detection.timestamp.desc()).limit(50).all()
    return render_template('history.html', detections=detections)

@app.route('/api/delete-detection/<int:detection_id>', methods=['DELETE'])
def delete_detection(detection_id):
    """Delete a detection and its associated image"""
    try:
        detection = Detection.query.get(detection_id)
        
        if not detection:
            return jsonify({'success': False, 'error': 'Detection not found'}), 404
        
        # Delete the image file if it exists
        image_path = os.path.join(app.config['UPLOAD_FOLDER'], detection.image_path.split('/')[-1])
        if os.path.exists(image_path):
            try:
                os.remove(image_path)
            except Exception as e:
                print(f"Error deleting image file: {e}")
        
        # Delete from database
        db.session.delete(detection)
        db.session.commit()
        
        return jsonify({'success': True, 'message': 'Detection deleted successfully'})
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/upload', methods=['POST'])
def api_upload():
    """API endpoint for image upload and detection"""
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400
    
    file = request.files['image']
    
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if not allowed_file(file.filename):
        # Get file extension for better error message
        if '.' in file.filename:
            ext = file.filename.rsplit('.', 1)[1].lower()
            error_msg = f'File type .{ext} is not supported. Please upload PNG, JPG, JPEG, GIF, BMP, WebP, TIFF, or TIF files.'
        else:
            error_msg = 'File must have a valid extension. Please upload PNG, JPG, JPEG, GIF, BMP, WebP, TIFF, or TIF files.'
        return jsonify({'error': error_msg}), 400
    
    # Save temporarily
    filename = secure_filename(file.filename)
    ext = filename.rsplit('.', 1)[1].lower()
    new_filename = f"temp_{uuid.uuid4()}.{ext}"
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], new_filename)
    file.save(filepath)
    
    # Call backend
    result = call_backend_detection(filepath)
    
    # Clean up temp file
    try:
        os.remove(filepath)
    except:
        pass
    
    if 'error' in result:
        return jsonify(result), 500
    
    return jsonify(result)

@app.route('/api/disease-info/<disease_name>')
def api_disease_info(disease_name):
    """API endpoint for disease information"""
    info = get_disease_info(disease_name)
    return jsonify(info)

@app.route('/static/uploads/<filename>')
def uploaded_file(filename):
    """Serve uploaded files"""
    return send_file(os.path.join(app.config['UPLOAD_FOLDER'], filename))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)