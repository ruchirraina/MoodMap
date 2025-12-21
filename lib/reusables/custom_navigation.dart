import 'package:flutter/material.dart';

// Function to navigate to a new screen with a slide-up animation
void navigatieSlideUp(
  BuildContext context,
  Widget screen, {
  bool replace = false, // Whether to replace the current screen
  int durationMs = 500, // Duration of the transition in milliseconds
}) {
  // Define the page route with custom slide-up transition
  final route = PageRouteBuilder(
    // Build the target screen
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    // Define the transition animation
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Define tween for slide-up effect
      final tween = Tween(
        begin: const Offset(0, 1), // Start from bottom of the screen
        end: Offset.zero, // End at original position
      ).chain(CurveTween(curve: Curves.easeInOutCubic));
      // chain the tween with a curve for smooth animation

      // Create the offset animation
      final offSetAnimation = animation.drive(tween);

      // Return the animated transition
      return SlideTransition(position: offSetAnimation, child: child);
    },
    // Set the duration of the transition
    transitionDuration: Duration(milliseconds: durationMs),
  );

  // Navigate to the new screen, replacing if specified
  replace
      ? Navigator.of(context).pushReplacement(route)
      : Navigator.of(context).push(route);
}

// Function to navigate to a new screen with a fade transition
void navigateFade(
  BuildContext context,
  Widget screen, {
  bool replace = true, // Whether to replace the current screen
  int durationMs = 300, // Duration of the transition in milliseconds
}) {
  // Define the page route with custom fade transition
  final route = PageRouteBuilder(
    // Define the target screen
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    // Define the transition animation
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    // Set the duration of the transition
    transitionDuration: Duration(milliseconds: durationMs),
  );

  // Navigate to the new screen, replacing if specified
  replace
      ? Navigator.of(context).pushReplacement(route)
      : Navigator.of(context).push(route);
}
