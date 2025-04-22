import 'package:flutter/material.dart';
import 'snackbar_helper.dart'; // Import the reusable snackbar helper

void showSuccessSnackBar(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showCustomSnackBar(
    context,
    title: title,
    message: message,
    svgIconPath: "assets/icons/check.svg", // Success icon
    backgroundColor: const Color(0xFF27AE60), // Success green
    iconColor: const Color(0xFF1F7A45), // Darker green for icon
    bubbleColor: const Color(0xFF219150), // Slightly deeper green for bubble
  );
}
