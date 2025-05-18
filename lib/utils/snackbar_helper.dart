import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String title,
  required String message,
  required String svgIconPath,
  required Color backgroundColor,
  required Color iconColor,
  required Color bubbleColor,
}) {
  final overlay = Overlay.of(context);
  final screenWidth = MediaQuery.of(context).size.width;
  final isDesktop = screenWidth >= 900;

  // Calculate the height based on the text length
  final titleTextHeight =
      (title.length > 30) ? 24.0 : 18.0; // Adjust based on title length
  final messageTextHeight =
      (message.length > 50) ? 36.0 : 24.0; // Adjust based on message length
  final totalHeight =
      titleTextHeight + messageTextHeight + 40.0; // Extra space for padding

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 30,
      right: isDesktop ? 30 : 16,
      left: isDesktop ? null : 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          height: totalHeight, // Adjusted height based on content
          width: isDesktop ? 480 : double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16), // slight adjust for mobile
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 40), // icon space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 12,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Bubbles background
              Positioned(
                bottom: -12,
                left: -12,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/bubbles.svg",
                    height: isDesktop ? 48 : 36,
                    width: isDesktop ? 40 : 30,
                    color: bubbleColor,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Top Icon (fail + custom icon)
              Positioned(
                top: isDesktop ? -30 : -20,
                left: -5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/fail.svg",
                      height: isDesktop ? 40 : 28,
                      color: iconColor,
                    ),
                    Positioned(
                      top: isDesktop ? 5 : 3,
                      child: SvgPicture.asset(
                        svgIconPath,
                        height: isDesktop ? 25 : 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Auto-remove after 3 seconds
  Future.delayed(const Duration(seconds: 3)).then((_) => overlayEntry.remove());
}
