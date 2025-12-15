import 'package:flutter/material.dart';

// Extension on BuildContext to show an error snackbar
extension ErrorSnackbar on BuildContext {
  void showErrorSnackbar(String message) {
    // Get status bar height and app bar height to calculate margins
    final double statusBarHeight = MediaQuery.of(this).padding.top;
    const double appBarHeight = kToolbarHeight;

    // Calculate top and bottom margins for the snackbar
    final double topMargin = statusBarHeight + appBarHeight;
    final double bottomMargin =
        MediaQuery.of(this).size.height - topMargin - 64;

    // Clear existing snackbars and show a new error snackbar
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        // Snackbar content and styling
        content: Text(message, style: Theme.of(this).textTheme.labelMedium),
        backgroundColor: Theme.of(this).colorScheme.errorContainer,
        elevation: 1,

        margin: EdgeInsets.only(bottom: bottomMargin, left: 24, right: 24),

        // Floating behavior for better visibility
        behavior: SnackBarBehavior.floating,

        // Allow dismissal by horizontal swipe
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
