import 'package:flutter/material.dart';
import '../models/detection_result.dart';
import '../services/database_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<DetectionResult> _history = [];
  List<DetectionResult> _recentResults = [];

  List<DetectionResult> get history => _history;
  List<DetectionResult> get recentResults => _recentResults;

  Future<void> loadHistory() async {
    _history = await DatabaseService.instance.getHistory();
    _recentResults = _history.take(10).toList();
    notifyListeners();
  }

  Future<void> addResult(DetectionResult result) async {
    await DatabaseService.instance.insertResult(result);
    _history.insert(0, result);
    _recentResults = _history.take(10).toList();
    notifyListeners();
  }

  Future<void> deleteResult(String id) async {
    await DatabaseService.instance.deleteResult(id);
    _history.removeWhere((r) => r.id == id);
    _recentResults = _history.take(10).toList();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await DatabaseService.instance.clearHistory();
    _history.clear();
    _recentResults.clear();
    notifyListeners();
  }
}