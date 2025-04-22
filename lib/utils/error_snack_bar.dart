import 'package:flutter/material.dart';
import 'snackbar_helper.dart'; // Import the reusable snackbar helper

void showErrorSnackBar(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showCustomSnackBar(
    context,
    title: title,
    message: message,
    svgIconPath: "assets/icons/error.svg", // Close X mark for error
    backgroundColor: const Color(0xFFC72C41), // Red for error
    iconColor: const Color(0xFF801336), // Darker red for icon
    bubbleColor: const Color(0xFF801336), // Slightly deeper red for bubble
  );
}
