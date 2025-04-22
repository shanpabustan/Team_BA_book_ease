// snackbar_helper.dart
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
  final screenWidth = MediaQuery.of(context).size.width;
  final isDesktop = screenWidth >= 900;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            width: isDesktop ? 480 : null, // wider for desktop
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(bottomLeft: Radius.circular(20)),
              child: SvgPicture.asset(
                "assets/icons/bubbles.svg",
                height: 48,
                width: 40,
                color: bubbleColor,
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/fail.svg",
                  height: 40,
                  color: iconColor,
                ),
                Positioned(
                  top: 5,
                  child: SvgPicture.asset(
                    svgIconPath,
                    height: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: isDesktop
          ? const EdgeInsets.only(left: 16, top: 16)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      duration: const Duration(seconds: 3),
    ),
  );
}
