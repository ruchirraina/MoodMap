import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moodmap/configs/theme_config.dart';
import 'package:moodmap/services/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:moodmap/start.dart';

// async main function to ensure proper initialization
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load Environment variables
  await dotenv.load(fileName: '.env');

  // Lock the app orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize shared preferences for theme management
  // Also Set the initial theme based on stored preference
  await ThemeService.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder to rebuild the app to trigger theme changes
    // whenever the themeNotifier value changes
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          title: 'MoodMap',

          debugShowCheckedModeBanner: false, // Disable debug banner

          theme:
              ThemeConfig.lightThemeConfig, // Use light theme from ThemeConfig

          darkTheme:
              ThemeConfig.darkThemeConfig, // Use dark theme from ThemeConfig

          themeMode: currentThemeMode, // Set theme mode based on notifier

          home: Start(),
        );
      },
    );
  }
}
