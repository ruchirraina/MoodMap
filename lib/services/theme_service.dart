import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static SharedPreferences? _prefs; // SharedPreferences instance variable

  // ValueNotifier to manage theme changes across the app
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  static const String _themeKey = 'theme_mode'; // Key for storing theme value
  // Key for storing if theme is set
  static const String _isThemeSetKey = 'is_theme_set';
  static bool _isThemeSet = false; // Storing if theme is set (default false)

  static Future<void> init() async {
    // Initialize SharedPreferences
    _prefs ??= await SharedPreferences.getInstance();
    // Set the initial theme based on stored preference
    ThemeService.themeNotifier.value = ThemeService.getTheme();
    // Load the "isSet" state so it remembers if the user manually changed it
    _isThemeSet = _prefs?.getBool(_isThemeSetKey) ?? false;
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

  // Method to toggle theme from anywhere in the app
  static void toggleTheme() {
    final ThemeMode currentThemeMode = themeNotifier.value;
    ThemeMode newThemeMode;

    switch (currentThemeMode) {
      case .system:
        newThemeMode = .light;
        break;
      case .light:
        newThemeMode = .dark;
        break;
      case .dark:
        newThemeMode = .system;
        break;
    }

    themeNotifier.value = newThemeMode; // Update the notifier
    ThemeService.setTheme(newThemeMode); // Save the new theme
  }
}
