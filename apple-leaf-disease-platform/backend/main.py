"""
FastAPI Backend for Apple Leaf Disease Detection
Handles ONNX model inference and serves API endpoints
"""

from fastapi import FastAPI, File, UploadFile, HTTPException
from contextlib import asynccontextmanager
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
from PIL import Image
import io
import base64
import cv2
import numpy as np
from ultralytics import YOLO
import torch
import logging
from datetime import datetime
import os
from typing import Dict, List
import json
import random
from config import SERVER_CONFIG, MODEL_CONFIG

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Load ONNX model on startup with mock fallback"""
    global model_session
    try:
        model_path = MODEL_CONFIG['path']
        if not os.path.exists(model_path):
            logger.warning(f"Model file not found at {model_path}. Switching to fallback mode.")
            model_session = None
        elif os.path.getsize(model_path) == 0:
            logger.warning(f"Model file at {model_path} is empty. Switching to fallback mode.")
            model_session = None
        else:
            # Load YOLO model
            model_session = YOLO(model_path)
            # Use names from the model itself for perfect accuracy
            global class_names
            if hasattr(model_session, 'names') and model_session.names:
                class_names = list(model_session.names.values())
                logger.info(f"Loaded {len(class_names)} class names from model.")
            
            logger.info(f"YOLO Model loaded successfully from {model_path}")
    except Exception as e:
        logger.error(f"Failed to load model: {str(e)}")
        model_session = None
    yield  # App runs here

app = FastAPI(title="Apple Leaf Disease Detection API", version="1.0.0", lifespan=lifespan)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables
model_session = None
# Standard Apple model classes (and common others in the same dataset)
class_names = [
    'Apple Scab', 'Apple Black Rot', 'Cedar Apple Rust', 'Apple Healthy',
    'Blueberry Healthy', 'Cherry Powdery Mildew', 'Cherry Healthy',
    'Corn Cercospora Leaf Spot', 'Corn Common Rust', 'Corn Northern Leaf Blight', 'Corn Healthy',
    'Grape Black Rot', 'Grape Esca', 'Grape Leaf Blight', 'Grape Healthy'
]

# Disease information database
DISEASE_INFO = {
    "Apple Scab": {
        "description": "Apple scab is a fungal disease caused by Venturia inaequalis. It appears as olive-green to brown spots on leaves and fruit.",
        "symptoms": [
            "Olive-green to brown spots on leaves",
            "Leaves may curl and fall prematurely",
            "Dark, scabby lesions on fruit",
            "Corky, cracked areas on fruit surface"
        ],
        "organic_treatment": [
            "Apply neem oil spray every 7-10 days",
            "Use sulfur-based fungicides",
            "Remove and destroy infected leaves",
            "Maintain good air circulation through pruning",
            "Apply compost tea as foliar spray"
        ],
        "chemical_treatment": [
            "Apply myclobutanil fungicides",
            "Use captan or mancozeb",
            "Apply during early spring before infection",
            "Follow label instructions for dosage"
        ],
        "prevention": [
            "Plant resistant apple varieties",
            "Ensure proper tree spacing for air circulation",
            "Clean up fallen leaves in autumn",
            "Apply dormant oil in late winter",
            "Monitor trees regularly for early signs"
        ],
        "seasonal_care": {
            "spring": "Apply preventive fungicides before bud break",
            "summer": "Monitor regularly and treat at first signs",
            "fall": "Rake and destroy fallen leaves",
            "winter": "Prune to improve air circulation"
        }
    },
    "Black Rot": {
        "description": "Black rot is a fungal disease caused by Botryosphaeria obtusa. It affects leaves, fruit, and branches.",
        "symptoms": [
            "Purple spots on leaves that enlarge",
            "Frogeye lesions with purple borders",
            "Brown, sunken areas on fruit",
            "Cankers on branches and twigs"
        ],
        "organic_treatment": [
            "Apply copper-based fungicides",
            "Remove infected plant parts immediately",
            "Use Bacillus subtilis based products",
            "Apply compost tea for prevention"
        ],
        "chemical_treatment": [
            "Apply thiophanate-methyl",
            "Use captan sprays during growing season",
            "Apply during early infection stages",
            "Rotate fungicides to prevent resistance"
        ],
        "prevention": [
            "Prune out dead or diseased branches",
            "Avoid overhead irrigation",
            "Remove mummified fruit from trees",
            "Maintain tree vigor with proper nutrition",
            "Sterilize pruning tools between cuts"
        ],
        "seasonal_care": {
            "spring": "Prune out infected branches before growth",
            "summer": "Remove infected fruit and leaves",
            "fall": "Clean up all fallen fruit and leaves",
            "winter": "Inspect and prune out cankers"
        }
    },
    "Cedar Apple Rust": {
        "description": "Cedar apple rust is a fungal disease that requires both apple and cedar trees to complete its life cycle.",
        "symptoms": [
            "Bright orange-yellow spots on leaves",
            "Tubular structures on leaf undersides",
            "Premature leaf drop",
            "Galls on young fruit"
        ],
        "organic_treatment": [
            "Apply sulfur powder during early season",
            "Use copper soap fungicides",
            "Remove nearby cedar trees if possible",
            "Apply baking soda solution (1 tbsp per gallon)"
        ],
        "chemical_treatment": [
            "Apply myclobutanil fungicides",
            "Use propiconazole products",
            "Apply during pink stage of bloom",
            "Treat every 10-14 days in wet weather"
        ],
        "prevention": [
            "Plant resistant apple varieties",
            "Remove nearby cedar trees (within 1-2 miles)",
            "Apply preventive fungicides in spring",
            "Maintain good air circulation",
            "Monitor for galls on cedar trees"
        ],
        "seasonal_care": {
            "spring": "Apply fungicides from pink through petal fall",
            "summer": "Remove infected leaves and fruit",
            "fall": "Remove galls from cedar trees",
            "winter": "Prune out galls on cedars"
        }
    },
    "Healthy": {
        "description": "Your apple leaf appears healthy! Continue good maintenance practices to keep it that way.",
        "symptoms": [
            "No visible disease symptoms",
            "Normal green color",
            "Intact leaf surface",
            "Uniform growth"
        ],
        "organic_treatment": [
            "Continue regular maintenance",
            "Apply compost or organic mulch",
            "Use seaweed extract for plant health",
            "Maintain proper watering schedule"
        ],
        "chemical_treatment": [
            "No treatment needed",
            "Continue preventive spraying if in season",
            "Follow regular orchard management"
        ],
        "prevention": [
            "Regular monitoring for early detection",
            "Maintain good orchard hygiene",
            "Proper fertilization and watering",
            "Prune regularly for good air flow",
            "Remove any suspicious leaves promptly"
        ],
        "seasonal_care": {
            "spring": "Apply balanced organic fertilizer",
            "summer": "Monitor for pests and diseases",
            "fall": "Clean up fallen leaves",
            "winter": "Plan next year's management"
        }
    }
}



def preprocess_image(image: Image.Image) -> np.ndarray:
    """Preprocess image for model inference"""
    # Convert to RGB if needed
    if image.mode != 'RGB':
        image = image.convert('RGB')
    
    # Resize
    image = image.resize((input_size, input_size))
    
    # Convert to array and normalize
    img_array = np.array(image).astype(np.float32) / 255.0
    
    # Normalize using ImageNet stats (adjust if your model uses different)
    mean = np.array([0.485, 0.456, 0.406])
    std = np.array([0.229, 0.224, 0.225])
    img_array = (img_array - mean) / std
    
    # Add batch dimension and transpose to (batch, channels, height, width)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = np.transpose(img_array, (0, 3, 1, 2))
    
    return img_array.astype(np.float32)

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Apple Leaf Disease Detection API",
        "version": "1.0.0",
        "endpoints": [
            "/health",
            "/detect",
            "/disease-info/{disease_name}",
            "/class-names"
        ]
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "model_loaded": model_session is not None,
        "timestamp": datetime.now().isoformat()
    }

@app.get("/class-names")
async def get_class_names():
    """Get list of disease classes"""
    return {"classes": class_names}

@app.post("/detect")
async def detect_disease(file: UploadFile = File(...)):
    """
    Detect disease from uploaded image (with mock fallback)
    """
    # If model is not loaded, check if we can use mock mode
    if model_session is None:
        if SERVER_CONFIG.get('mock_mode'):
            # Provide a mock result
            mock_class = random.choice(class_names)
            mock_confidence = random.uniform(85.0, 99.0)
            
            all_probs = {name: 0.0 for name in class_names}
            all_probs[mock_class] = mock_confidence
            # Add some noise to others
            remaining = 100.0 - mock_confidence
            for name in class_names:
                if name != mock_class:
                    p = random.uniform(0, remaining)
                    all_probs[name] = round(p, 2)
                    remaining -= p
            
            result = {
                "success": True,
                "disease": mock_class,
                "confidence": round(mock_confidence, 2),
                "all_probabilities": all_probs,
                "timestamp": datetime.now().isoformat(),
                "mode": "mock"
            }
            logger.info(f"Mock Detection successful: {mock_class} ({mock_confidence:.2f}%)")
            return JSONResponse(content=result)
        else:
            raise HTTPException(status_code=503, detail="Model not loaded and Mock Mode is disabled")
    
    # Validate file type
    if file.content_type and not file.content_type.startswith('image/'):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    try:
        # Read image
        contents = await file.read()
        image = Image.open(io.BytesIO(contents))
        
        # Run YOLO inference
        logger.info("Running YOLO inference...")
        results = model_session.predict(image, conf=0.25)[0]
        logger.info(f"YOLO inference complete. Result type: {type(results)}")
        
        # Get results (detect if it's classification or detection)
        if hasattr(results, 'probs') and results.probs is not None:
            logger.info("Handling as Classification model")
            probs = results.probs.data.tolist()
            predicted_idx = int(results.probs.top1)
            predicted_class = class_names[predicted_idx] if predicted_idx < len(class_names) else f"Class {predicted_idx}"
            confidence = float(results.probs.top1conf * 100)
            
            all_probs = {}
            for i, class_name in enumerate(class_names):
                if i < len(probs):
                    all_probs[class_name] = round(float(probs[i] * 100), 2)
        else:
            logger.info(f"Handling as Detection model. Boxes found: {len(results.boxes)}")
            if len(results.boxes) > 0:
                box = results.boxes[0]
                predicted_idx = int(box.cls[0])
                predicted_class = class_names[predicted_idx] if predicted_idx < len(class_names) else f"Class {predicted_idx}"
                confidence = float(box.conf[0] * 100)
                
                all_probs = {name: 0.0 for name in class_names}
                if predicted_class in all_probs:
                    all_probs[predicted_class] = round(confidence, 2)
            else:
                predicted_class = "Healthy"
                confidence = 100.0
                all_probs = {"Healthy": 100.0, "Apple Scab": 0.0, "Black Rot": 0.0, "Cedar Apple Rust": 0.0}

        # Draw boxes on the image
        annotated_frame = results.plot()  # BGR array
        annotated_image_rgb = cv2.cvtColor(annotated_frame, cv2.COLOR_BGR2RGB)
        pil_img = Image.fromarray(annotated_image_rgb)
        
        # Convert to base64 to send to frontend
        buffered = io.BytesIO()
        pil_img.save(buffered, format="JPEG")
        img_str = base64.b64encode(buffered.getvalue()).decode()

        # Prepare response
        result = {
            "success": True,
            "disease": predicted_class,
            "confidence": round(confidence, 2),
            "all_probabilities": all_probs,
            "annotated_image": img_str, # Send image with boxes back!
            "timestamp": datetime.now().isoformat()
        }
        
        logger.info(f"Detection successful: {predicted_class} ({confidence:.2f}%)")
        return JSONResponse(content=result)
        
    except Exception as e:
        logger.error(f"Detection failed: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Detection failed: {str(e)}")

@app.get("/disease-info/{disease_name}")
async def get_disease_info(disease_name: str):
    """Get detailed information about a specific disease"""
    disease_name = disease_name.strip()
    
    # Try to find matching disease
    for key in DISEASE_INFO.keys():
        if disease_name.lower() in key.lower():
            return {
                "success": True,
                "disease": key,
                "info": DISEASE_INFO[key]
            }
    
    # If not found, return first matching or all
    for key in class_names:
        if disease_name.lower() in key.lower():
            return {
                "success": True,
                "disease": key,
                "info": DISEASE_INFO.get(key, DISEASE_INFO["Healthy"])
            }
    
    raise HTTPException(status_code=404, detail="Disease information not found")

@app.get("/all-diseases")
async def get_all_diseases():
    """Get information about all diseases"""
    return {
        "success": True,
        "diseases": DISEASE_INFO
    }

if __name__ == "__main__":
    # Use "main:app" string instead of app object to enable reload=True
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)