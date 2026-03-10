import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async {
    // Check camera permission
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      throw Exception('Camera permission denied');
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image from camera: $e');
      rethrow;
    }

    return null;
  }

  Future<File?> pickImageFromGallery() async {
    // Check storage permission
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      throw Exception('Storage permission denied');
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      rethrow;
    }

    return null;
  }

  Future<List<File>> pickMultipleImages() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      throw Exception('Storage permission denied');
    }

    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      return pickedFiles.map((f) => File(f.path)).toList();
    } catch (e) {
      print('Error picking multiple images: $e');
      rethrow;
    }
  }

  Future<File> optimizeImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(imageBytes);

      if (originalImage != null) {
        // Resize if too large
        const maxSize = 1024;
        img.Image processedImage;

        if (originalImage.width > maxSize || originalImage.height > maxSize) {
          processedImage = img.copyResize(
            originalImage,
            width: originalImage.width > maxSize ? maxSize : null,
            height: originalImage.height > maxSize ? maxSize : null,
          );
        } else {
          processedImage = originalImage;
        }

        // Compress image
        final optimizedBytes = img.encodeJpg(processedImage, quality: 85);
        
        // Save optimized image
        final directory = await imageFile.parent;
        final optimizedPath = '${directory.path}/optimized_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final optimizedFile = File(optimizedPath);
        await optimizedFile.writeAsBytes(optimizedBytes);

        // Delete original
        await imageFile.delete();

        return optimizedFile;
      }
    } catch (e) {
      print('Error optimizing image: $e');
    }

    return imageFile;
  }
}