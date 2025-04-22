import 'package:flutter/material.dart';
import 'snackbar_helper.dart'; // Import the reusable snackbar helper

void showWarningSnackBar(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showCustomSnackBar(
    context,
    title: title,
    message: message,
    svgIconPath: "assets/icons/warning.svg", // Warning icon
    backgroundColor: const Color(0xFFE67E22), // Warning amber
    iconColor: const Color(0xFFBA4A00), // Darker orange for icon
    bubbleColor: const Color(0xFFD35400), // Slightly deeper orange for bubble
  );
}
