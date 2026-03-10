"""
ONNX Model Inference Module
"""

import onnxruntime as ort
import numpy as np
from PIL import Image
import logging

logger = logging.getLogger(__name__)

class DiseaseDetector:
    def __init__(self, model_path: str):
        self.model_path = model_path
        self.session = None
        self.class_names = ['Apple Scab', 'Black Rot', 'Cedar Apple Rust', 'Healthy']
        self.input_size = 224
        self.mean = np.array([0.485, 0.456, 0.406])
        self.std = np.array([0.229, 0.224, 0.225])
        self.load_model()
    
    def load_model(self):
        """Load ONNX model"""
        try:
            self.session = ort.InferenceSession(self.model_path)
            logger.info(f"Model loaded from {self.model_path}")
            
            # Log model info
            for input in self.session.get_inputs():
                logger.info(f"Input: {input.name}, shape: {input.shape}")
            for output in self.session.get_outputs():
                logger.info(f"Output: {output.name}, shape: {output.shape}")
                
        except Exception as e:
            logger.error(f"Failed to load model: {e}")
            self.session = None
    
    def preprocess(self, image: Image.Image) -> np.ndarray:
        """Preprocess image for inference"""
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Resize
        image = image.resize((self.input_size, self.input_size))
        
        # Convert to array
        img_array = np.array(image).astype(np.float32) / 255.0
        
        # Normalize
        img_array = (img_array - self.mean) / self.std
        
        # Add batch and transpose
        img_array = np.expand_dims(img_array, axis=0)
        img_array = np.transpose(img_array, (0, 3, 1, 2))
        
        return img_array.astype(np.float32)
    
    def predict(self, image: Image.Image) -> dict:
        """Run inference on image"""
        if self.session is None:
            raise RuntimeError("Model not loaded")
        
        # Preprocess
        input_tensor = self.preprocess(image)
        
        # Get input name
        input_name = self.session.get_inputs()[0].name
        
        # Run inference
        outputs = self.session.run(None, {input_name: input_tensor})
        
        # Get probabilities
        probabilities = outputs[0][0]
        
        # Apply softmax
        probabilities = np.exp(probabilities) / np.sum(np.exp(probabilities))
        
        # Get predicted class
        predicted_idx = np.argmax(probabilities)
        predicted_class = self.class_names[predicted_idx]
        confidence = float(probabilities[predicted_idx] * 100)
        
        # Get all probabilities
        all_probs = {}
        for i, class_name in enumerate(self.class_names):
            all_probs[class_name] = float(probabilities[i] * 100)
        
        # Sort by confidence
        all_probs = dict(sorted(all_probs.items(), key=lambda x: x[1], reverse=True))
        
        return {
            "disease": predicted_class,
            "confidence": round(confidence, 2),
            "all_probabilities": all_probs
        }
    
    def predict_batch(self, images: list) -> list:
        """Run inference on multiple images"""
        results = []
        for image in images:
            results.append(self.predict(image))
        return results