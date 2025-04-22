import 'package:flutter/material.dart';

void addToMyBooks(BuildContext context, String bookTitle) {
  // Animation key
  final GlobalKey _key = GlobalKey();

  // Create an overlay to display the animation
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        key: _key,
        top: 100, // Adjust based on your UI
        left: 100, // Adjust based on your UI
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: value,
                child: Icon(
                  Icons.bookmark,
                  color: Colors.teal,
                  size: 40,
                ),
              ),
            );
          },
          onEnd: () {
            overlayEntry!.remove();
            // Add your function to handle adding the book to My Books
            // Call the function to save to My Books here
          },
        ),
      );
    },
  );

  Overlay.of(context).insert(overlayEntry);
}
