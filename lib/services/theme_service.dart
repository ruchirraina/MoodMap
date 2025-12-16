import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static SharedPreferences? _prefs; // SharedPreferences instance variable

  static const String _themeKey = 'theme_mode'; // Key for storing theme value
  // Key for storing if theme is set
  static const String _isThemeSetKey = 'is_theme_set';
  static bool _isThemeSet = false; // Storing if theme is set (default false)

  static Future<void> init() async {
    // Initialize SharedPreferences
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save theme mode using its index (0: system, 1: light, 2: dark)
  static Future<void> setTheme(ThemeMode mode) async {
    // Use .index property for simple integer storage
    await _prefs?.setInt(_themeKey, mode.index);
    _isThemeSet = true;
    await _prefs?.setBool(_isThemeSetKey, _isThemeSet);
  }

  // Retrieve theme mode, defaulting to system if not set
  static ThemeMode getTheme() {
    // Retrieve integer index, default to 0 (ThemeMode.system)
    final int index = _prefs?.getInt(_themeKey) ?? 0;
    // Convert index back to ThemeMode enum.
    // Use safety check just in case the stored value is out of bounds.
    if (index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.system;
  }

  // Getter returning bool for if theme is set
  static bool get isThemeSet => _isThemeSet;
}
