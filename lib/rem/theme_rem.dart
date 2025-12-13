import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRemember {
  static SharedPreferences? _prefs; // SharedPreferences instance variable

  static const String _themeKey = 'theme'; // Key for storing theme value
  // Default theme value (0: system, 1: light, 2: dark)
  static int _themeVal = 0;

  // Key for storing if the theme has been set
  static const String _isThemSetKey = 'isThemeSet';
  static bool _isThemeSet = false; // Default value for theme set status

  static Future<void> init() async {
    // Initialize SharedPreferences
    _prefs ??= await SharedPreferences.getInstance();
  }

  static void setTheme(ThemeMode mode) {
    // Set theme value based on ThemeMode
    switch (mode) {
      case ThemeMode.system:
        _themeVal = 0;
        break;
      case ThemeMode.light:
        _themeVal = 1;
        break;
      case ThemeMode.dark:
        _themeVal = 2;
        break;
    }
    _prefs?.setInt(_themeKey, _themeVal); // Save theme value
    _isThemeSet = true;
    _prefs?.setBool(_isThemSetKey, _isThemeSet); // Save theme set status
  }

  static ThemeMode getTheme() {
    // Retrieve theme value and return corresponding ThemeMode
    // If not set, default to system theme
    _themeVal = _prefs?.getInt(_themeKey) ?? 0;
    // Retrieve theme set status. If not set, default to false
    _isThemeSet = _prefs?.getBool(_isThemSetKey) ?? false;
    // Return ThemeMode based on stored value
    switch (_themeVal) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static bool get isThemeSet => _isThemeSet; // Getter for theme set status
}
