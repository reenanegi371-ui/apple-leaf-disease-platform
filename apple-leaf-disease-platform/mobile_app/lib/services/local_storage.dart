import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/detection_result.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _historyKey = 'detection_history';
  static const String _settingsKey = 'app_settings';
  static const String _userPrefsKey = 'user_preferences';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // History Methods
  Future<void> saveDetectionResult(DetectionResult result) async {
    final history = await getDetectionHistory();
    history.insert(0, result);
    
    // Keep only last 100 items
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }

    final jsonList = history.map((r) => json.encode(r.toJson())).toList();
    await _prefs?.setStringList(_historyKey, jsonList);
  }

  Future<List<DetectionResult>> getDetectionHistory() async {
    final jsonList = _prefs?.getStringList(_historyKey) ?? [];
    return jsonList
        .map((jsonString) => DetectionResult.fromJson(json.decode(jsonString)))
        .toList();
  }

  Future<void> clearHistory() async {
    await _prefs?.remove(_historyKey);
  }

  Future<void> deleteDetectionResult(String id) async {
    final history = await getDetectionHistory();
    history.removeWhere((r) => r.id == id);
    
    final jsonList = history.map((r) => json.encode(r.toJson())).toList();
    await _prefs?.setStringList(_historyKey, jsonList);
  }

  // Settings Methods
  Future<void> saveSetting(String key, dynamic value) async {
    final settings = await getSettings();
    settings[key] = value;
    await _prefs?.setString(_settingsKey, json.encode(settings));
  }

  Future<Map<String, dynamic>> getSettings() async {
    final settingsJson = _prefs?.getString(_settingsKey) ?? '{}';
    return json.decode(settingsJson);
  }

  Future<T?> getSetting<T>(String key) async {
    final settings = await getSettings();
    return settings[key];
  }

  // User Preferences
  Future<void> saveUserPreference(String key, dynamic value) async {
    final prefs = await getUserPreferences();
    prefs[key] = value;
    await _prefs?.setString(_userPrefsKey, json.encode(prefs));
  }

  Future<Map<String, dynamic>> getUserPreferences() async {
    final prefsJson = _prefs?.getString(_userPrefsKey) ?? '{}';
    return json.decode(prefsJson);
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _prefs?.clear();
  }

  // Check if first launch
  Future<bool> isFirstLaunch() async {
    final firstLaunch = _prefs?.getBool('first_launch') ?? true;
    if (firstLaunch) {
      await _prefs?.setBool('first_launch', false);
    }
    return firstLaunch;
  }
}