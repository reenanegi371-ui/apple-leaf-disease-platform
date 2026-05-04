"""
Database models for the Flask website
"""

from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class Detection(db.Model):
    """Model for storing detection history"""
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(255), nullable=False)
    image_path = db.Column(db.String(255), nullable=False)
    disease = db.Column(db.String(100), nullable=False)
    confidence = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    disease_info = db.Column(db.Text)  # JSON string of disease info

    def to_dict(self):
        """Convert to dictionary for JSON response"""
        return {
            'id': self.id,
            'filename': self.filename,
            'image_path': self.image_path,
            'disease': self.disease,
            'confidence': self.confidence,
            'timestamp': self.timestamp.isoformat(),
            'disease_info': self.disease_info
        }