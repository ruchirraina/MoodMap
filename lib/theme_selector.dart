import 'package:flutter/material.dart';
import 'package:moodmap/services/theme_service.dart';
import 'package:moodmap/reusables/theme_extension.dart';

({Icon themeIcon, String themeTitle}) getThemeModeInfo(ThemeMode mode) {
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
        themeIcon: Icon(Icons.brightness_auto, size: 110),
        themeTitle: 'Follow System',
      );
  }
}

Widget themeSelect(BuildContext context) {
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

          // Press to toggle theme
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
            ),
            onPressed: () {
              ThemeService.toggleTheme();
            },
            child: getThemeModeInfo(ThemeService.themeNotifier.value).themeIcon,
          ),

          const SizedBox(height: 12),

          Text(getThemeModeInfo(ThemeService.themeNotifier.value).themeTitle),

          const SizedBox(height: 28),

          FilledButton(onPressed: () {}, child: Text("Continue")),
        ],
      ),
    ),
  );
}
