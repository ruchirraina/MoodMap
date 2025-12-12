import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// async main function to ensure proper initialization
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Define a seed color for the app theme
  final Color _appColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodMap',

      debugShowCheckedModeBanner: false, // Disable debug banner

      theme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Poppins',

        // Light theme configuration
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: _appColor,
              surface: const Color(0xFFF5F5F5), // Soft white surface color
              onSurface: Colors.black,
              brightness: Brightness.light, // For light theme
            ).copyWith(
              surfaceContainerLowest: const Color(0xFFFFFFFF),
              surfaceContainerLow: const Color(0xFFF9F9F9),
              surfaceContainer: const Color(0xFFF3F3F3),
              surfaceContainerHigh: const Color(0xFFEDEDED),
              surfaceContainerHighest: const Color(0xFFE8E8E8),
            ), // Customize surface colors

        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ), // Center app bar titles

        cardTheme: CardThemeData(
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          surfaceTintColor: Colors.transparent,
        ), // Customize card appearance

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ), // Customize filled button appearance
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.15),
            surfaceTintColor: Colors.transparent,
          ), // Customize elevated button appearance
        ),

        splashFactory: Platform.isAndroid
            ? InkRipple.splashFactory
            : InkSparkle.splashFactory, // Platform-specific splash effect
      ),

      darkTheme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Poppins',

        // Dark theme configuration
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: _appColor,
              surface: const Color(
                0xFF0E0E0E,
              ), // Close to pitch black surface color
              onSurface: Colors.white,
              brightness: Brightness.dark, // For dark theme
            ).copyWith(
              surfaceContainerLowest: const Color(0xFF0A0A0A),
              surfaceContainerLow: const Color(0xFF121212),
              surfaceContainer: const Color(0xFF1A1A1A),
              surfaceContainerHigh: const Color(0xFF222222),
              surfaceContainerHighest: const Color(0xFF2A2A2A),
            ), // Customize surface colors

        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ), // Center app bar titles

        cardTheme: CardThemeData(
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          surfaceTintColor: Colors.transparent,
        ), // Customize card appearance

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ), // Customize filled button appearance
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.5),
            surfaceTintColor: Colors.transparent,
          ), // Customize elevated button appearance
        ),

        splashFactory: Platform.isAndroid
            ? InkRipple.splashFactory
            : InkSparkle.splashFactory, // Platform-specific splash effect
      ),
    );
  }
}
