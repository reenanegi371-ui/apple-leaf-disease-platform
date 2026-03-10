"""
Image Preprocessing Module for ONNX Model Inference
"""

import numpy as np
from PIL import Image
import logging
from typing import Tuple, Optional
import cv2

logger = logging.getLogger(__name__)

class ImagePreprocessor:
    """Handles image preprocessing for model inference"""
    
    def __init__(self, input_size: int = 224, 
                 mean: list = [0.485, 0.456, 0.406],
                 std: list = [0.229, 0.224, 0.225]):
        self.input_size = input_size
        self.mean = np.array(mean)
        self.std = np.array(std)
    
    def preprocess(self, image: Image.Image) -> np.ndarray:
        """
        Preprocess image for model inference
        Args:
            image: PIL Image object
        Returns:
            Preprocessed numpy array ready for model input
        """
        try:
            # Convert to RGB if needed
            if image.mode != 'RGB':
                image = image.convert('RGB')
            
            # Resize
            image = image.resize((self.input_size, self.input_size))
            
            # Convert to numpy array and normalize to [0,1]
            img_array = np.array(image).astype(np.float32) / 255.0
            
            # Normalize using mean and std
            img_array = (img_array - self.mean) / self.std
            
            # Add batch dimension and transpose to (batch, channels, height, width)
            img_array = np.expand_dims(img_array, axis=0)
            img_array = np.transpose(img_array, (0, 3, 1, 2))
            
            logger.debug(f"Preprocessed image shape: {img_array.shape}")
            return img_array.astype(np.float32)
            
        except Exception as e:
            logger.error(f"Error preprocessing image: {str(e)}")
            raise
    
    def preprocess_batch(self, images: list) -> np.ndarray:
        """
        Preprocess multiple images for batch inference
        Args:
            images: List of PIL Image objects
        Returns:
            Batch of preprocessed images
        """
        batch = []
        for image in images:
            processed = self.preprocess(image)
            batch.append(processed[0])  # Remove batch dimension for stacking
        
        # Stack all images
        batch_array = np.stack(batch, axis=0)
        logger.debug(f"Batch shape: {batch_array.shape}")
        return batch_array
    
    def resize_with_aspect_ratio(self, image: Image.Image, target_size: int) -> Image.Image:
        """
        Resize image while maintaining aspect ratio
        """
        width, height = image.size
        
        if width > height:
            new_width = target_size
            new_height = int(height * (target_size / width))
        else:
            new_height = target_size
            new_width = int(width * (target_size / height))
        
        return image.resize((new_width, new_height))
    
    def center_crop(self, image: Image.Image, crop_size: int) -> Image.Image:
        """
        Center crop image to specified size
        """
        width, height = image.size
        
        left = (width - crop_size) // 2
        top = (height - crop_size) // 2
        right = left + crop_size
        bottom = top + crop_size
        
        return image.crop((left, top, right, bottom))
    
    def enhance_image(self, image: Image.Image) -> Image.Image:
        """
        Enhance image quality for better inference
        """
        # Convert to numpy array for OpenCV processing
        img_array = np.array(image)
        
        # Apply CLAHE (Contrast Limited Adaptive Histogram Equalization)
        lab = cv2.cvtColor(img_array, cv2.COLOR_RGB2LAB)
        l, a, b = cv2.split(lab)
        clahe = cv2.createCLAHE(clipLimit=3.0, tileGridSize=(8,8))
        l = clahe.apply(l)
        lab = cv2.merge([l, a, b])
        enhanced = cv2.cvtColor(lab, cv2.COLOR_LAB2RGB)
        
        # Sharpen image
        kernel = np.array([[-1,-1,-1],
                          [-1, 9,-1],
                          [-1,-1,-1]])
        sharpened = cv2.filter2D(enhanced, -1, kernel)
        
        return Image.fromarray(sharpened)
    
    def validate_image(self, image: Image.Image) -> Tuple[bool, Optional[str]]:
        """
        Validate if image is suitable for inference
        """
        try:
            # Check minimum size
            min_size = 50
            if image.width < min_size or image.height < min_size:
                return False, f"Image too small. Minimum size: {min_size}px"
            
            # Check aspect ratio
            aspect_ratio = image.width / image.height
            if aspect_ratio < 0.5 or aspect_ratio > 2.0:
                return False, "Extreme aspect ratio may affect results"
            
            # Check for sufficient detail (using Laplacian variance)
            img_array = np.array(image.convert('L'))
            laplacian_var = cv2.Laplacian(img_array, cv2.CV_64F).var()
            
            if laplacian_var < 10:
                return False, "Image too blurry for accurate detection"
            
            return True, None
            
        except Exception as e:
            return False, str(e)
    
    def get_preprocessing_info(self) -> dict:
        """Get preprocessing configuration info"""
        return {
            'input_size': self.input_size,
            'mean': self.mean.tolist(),
            'std': self.std.tolist(),
            'normalization': 'mean/std',
            'color_mode': 'RGB'
        }

# Singleton instance for easy import
preprocessor = ImagePreprocessor()