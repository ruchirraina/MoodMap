import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodmap/services/theme_service.dart';
import 'package:moodmap/reusables/theme_extension.dart';

void _continueToLogin(BuildContext context, VoidCallback onContinue) {
  // gives physical vibration feedback when the button is pressed
  HapticFeedback.selectionClick();

  // saves the choice to disk so the app remembers it next time
  ThemeService.setTheme(ThemeService.themeNotifier.value);

  // start slide up animation and proceed to auth screen
  onContinue();
}

Widget themeSelector(BuildContext context, {required VoidCallback onContinue}) {
  return SafeArea(
    child: Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            'Choose your theme',
            style: context.textTheme.titleLarge!.copyWith(fontWeight: .bold),
          ),

          const SizedBox(height: 20),

          // circular button acting as a giant toggle switch
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const .all(24),
            ),
            onPressed: () {
              // toggles the global theme notifier
              ThemeService.toggleTheme();
            },
            child: _getThemeModeInfo(
              ThemeService.themeNotifier.value,
            ).themeIcon,
          ),

          const SizedBox(height: 12),

          // dynamic text label based on the current theme
          Text(_getThemeModeInfo(ThemeService.themeNotifier.value).themeTitle),

          const SizedBox(height: 28),

          FilledButton(
            onPressed: () => _continueToLogin(context, onContinue),
            child: const Text("Continue"),
          ),
        ],
      ),
    ),
  );
}

// records: a way to return multiple named values from one function
// useful here to group the icon and the text label together
({Icon themeIcon, String themeTitle}) _getThemeModeInfo(ThemeMode mode) {
  switch (mode) {
    case .light:
      return (
        themeIcon: Icon(
          Icons.light_mode,
          color: Colors.amber.shade400,
          size: 110,
        ),
        themeTitle: 'Light Mode',
      );
    case .dark:
      return (
        themeIcon: Icon(
          Icons.dark_mode,
          color: Colors.yellow.shade100,
          size: 110,
        ),
        themeTitle: 'Dark Mode',
      );
    default:
      return (
        themeIcon: const Icon(Icons.brightness_auto, size: 110),
        themeTitle: 'Follow System',
      );
  }
}
