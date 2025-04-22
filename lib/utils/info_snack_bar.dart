import 'package:flutter/material.dart';
import 'snackbar_helper.dart'; // Import the reusable snackbar helper

void showInfoSnackBar(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showCustomSnackBar(
    context,
    title: title,
    message: message,
    svgIconPath: "assets/icons/info.svg", // Info icon
    backgroundColor: const Color(0xFF3498DB), // Info blue
    iconColor: const Color(0xFF2980B9), // Darker blue for icon
    bubbleColor: const Color(0xFF1A77B1), // Slightly deeper blue for bubble
  );
}
