import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class Validators {
  // Validate image file
  static String? validateImage(File? imageFile) {
    if (imageFile == null) {
      return 'Please select an image';
    }
    
    if (!imageFile.existsSync()) {
      return 'Image file does not exist';
    }
    
    // Check file size (max 10MB)
    const maxSize = 10 * 1024 * 1024;
    if (imageFile.lengthSync() > maxSize) {
      return 'Image size too large. Maximum 10MB';
    }
    
    // Check file extension
    final extension = imageFile.path.split('.').last.toLowerCase();
    const validExtensions = ['jpg', 'jpeg', 'png', 'bmp'];
    if (!validExtensions.contains(extension)) {
      return 'Invalid image format. Please use JPG, PNG, or BMP';
    }
    
    return null;
  }
  
  // Validate image content (can be decoded)
  static String? validateImageContent(File imageFile) {
    try {
      final bytes = imageFile.readAsBytesSync();
      final decodedImage = img.decodeImage(bytes);
      
      if (decodedImage == null) {
        return 'Invalid image file';
      }
      
      // Check minimum dimensions
      if (decodedImage.width < 50 || decodedImage.height < 50) {
        return 'Image is too small. Minimum 50x50 pixels';
      }
      
      return null;
    } catch (e) {
      return 'Failed to read image file';
    }
  }
  
  // Validate email
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    
    if (!regExp.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Validate name
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }
    
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (name.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    return null;
  }
  
  // Validate phone number
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return null; // Phone is optional
    }
    
    final pattern = r'^[0-9]{10}$';
    final regExp = RegExp(pattern);
    
    if (!regExp.hasMatch(phone)) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    return null;
  }
  
  // Validate URL
  static String? validateUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }
    
    final pattern = r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$';
    final regExp = RegExp(pattern);
    
    if (!regExp.hasMatch(url)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  // Validate password
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }
  
  // Validate password confirmation
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  // Validate search query
  static String? validateSearchQuery(String? query) {
    if (query == null || query.isEmpty) {
      return null;
    }
    
    if (query.length < 2) {
      return 'Search query must be at least 2 characters';
    }
    
    return null;
  }
  
  // Check if string contains only numbers
  static bool isNumeric(String str) {
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }
  
  // Check if string contains only letters
  static bool isAlphabetic(String str) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(str);
  }
  
  // Check if string is a valid disease name
  static bool isValidDiseaseName(String name) {
    const diseases = ['Apple Scab', 'Black Rot', 'Cedar Rust', 'Healthy'];
    return diseases.contains(name);
  }
  
  // Validate confidence score
  static bool isValidConfidence(double confidence) {
    return confidence >= 0 && confidence <= 100;
  }
}