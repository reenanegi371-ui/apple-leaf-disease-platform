import 'package:flutter/material.dart';
import '../models/detection_result.dart';
import '../models/disease_model.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class DetectionProvider extends ChangeNotifier {
  DetectionResult? _currentResult;
  bool _isLoading = false;
  String? _errorMessage;
  List<DetectionResult> _recentDetections = [];

  DetectionResult? get currentResult => _currentResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<DetectionResult> get recentDetections => _recentDetections;

  Future<void> detectDisease(String imagePath) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.detectDisease(imagePath);
      _currentResult = result;
      
      // Save to database
      await DatabaseService.instance.insertResult(result);
      
      // Update recent detections
      await loadRecentDetections();
      
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecentDetections() async {
    try {
      final history = await DatabaseService.instance.getHistory();
      _recentDetections = history.take(10).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading recent detections: $e');
    }
  }

  Future<void> clearCurrentResult() {
    _currentResult = null;
    notifyListeners();
    return Future.value();
  }

  Future<Disease?> getDiseaseInfo(String diseaseName) async {
    try {
      return await ApiService.getDiseaseInfo(diseaseName);
    } catch (e) {
      print('Error getting disease info: $e');
      return null;
    }
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}