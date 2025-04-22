import 'package:flutter/material.dart';

const Color secondaryColor = Color.fromRGBO(49, 120, 115, 1);

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = secondaryColor, // Default background color
    this.textColor = Colors.white, // Default text color
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor), // Set text color dynamically
      ),
    );
  }
}
