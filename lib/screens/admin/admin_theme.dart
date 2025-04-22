import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminColor {
  // Text Colors
  static const Color primaryTextColor = Color.fromRGBO(0, 0, 0, 1); // Black
  static const Color secondaryTextColor =
      Color.fromRGBO(255, 255, 255, 1); // White
  static const Color tertiaryTextColor =
      Color.fromRGBO(49, 120, 115, 1); // Green

  // Background Colors
  static const Color primaryBackgroundColor =
      Color.fromRGBO(250, 250, 250, 1); // Light background color
  static const Color secondaryBackgroundColor =
      Color.fromRGBO(49, 120, 115, 1); // Secondary color
  static const Color tertiaryBackgroundColor =
      Color.fromRGBO(110, 107, 107, 1); // Grey
  static const Color sidebarBackgroundColor =
      Color.fromRGBO(51, 53, 54, 1); // Sidebar

  // Border Colors
  static const Color borderColor =
      Color.fromRGBO(220, 220, 220, 1); // Light gray border
}

class AdminFontSize {
  static const double heading = 24.0;
  static const double subHeading = 18.0;
  static const double bodyText = 14.0;
  static const double labelText = 16.0;
  static const double buttonText = 16.0;
}

class AdminTextStyle {
  // Heading style
  static TextStyle heading() {
    return GoogleFonts.poppins(
      fontSize: AdminFontSize.heading,
      fontWeight: FontWeight.bold,
      color: AdminColor.primaryTextColor,
    );
  }

  // Subheading style
  static TextStyle subHeading() {
    return GoogleFonts.poppins(
      fontSize: AdminFontSize.subHeading,
      fontWeight: FontWeight.w600,
      color: AdminColor.primaryTextColor,
    );
  }

  // Body text style
  static TextStyle bodyText() {
    return GoogleFonts.poppins(
      fontSize: AdminFontSize.bodyText,
      fontWeight: FontWeight.normal,
      color: AdminColor.secondaryTextColor,
    );
  }

  // Label text style
  static TextStyle labelText() {
    return GoogleFonts.poppins(
      fontSize: AdminFontSize.labelText,
      fontWeight: FontWeight.normal,
      color: AdminColor.secondaryTextColor,
    );
  }

  // Button text style
  static TextStyle buttonText() {
    return GoogleFonts.poppins(
      fontSize: AdminFontSize.buttonText,
      fontWeight: FontWeight.w600,
      color: AdminColor.tertiaryTextColor,
    );
  }
}
