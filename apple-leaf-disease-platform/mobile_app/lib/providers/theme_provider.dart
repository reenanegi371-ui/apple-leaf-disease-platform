import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;
  final String _themePrefKey = 'theme_mode';

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themePrefKey);
    
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          _themeMode = ThemeMode.light;
          _isDarkMode = false;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          _isDarkMode = true;
          break;
        default:
          _themeMode = ThemeMode.system;
          _isDarkMode = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      }
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      _isDarkMode = true;
      await _saveThemePreference('dark');
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.system;
      _isDarkMode = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      await _saveThemePreference('system');
    } else {
      _themeMode = ThemeMode.light;
      _isDarkMode = false;
      await _saveThemePreference('light');
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _isDarkMode = mode == ThemeMode.dark || 
                  (mode == ThemeMode.system && 
                   WidgetsBinding.instance.window.platformBrightness == Brightness.dark);
    
    String prefValue = 'system';
    if (mode == ThemeMode.light) prefValue = 'light';
    if (mode == ThemeMode.dark) prefValue = 'dark';
    
    await _saveThemePreference(prefValue);
    notifyListeners();
  }

  Future<void> _saveThemePreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePrefKey, value);
  }

  void updateSystemTheme() {
    if (_themeMode == ThemeMode.system) {
      _isDarkMode = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      notifyListeners();
    }
  }
}