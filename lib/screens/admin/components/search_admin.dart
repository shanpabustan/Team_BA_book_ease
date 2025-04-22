import 'package:flutter/material.dart';

class SearchAdmin extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  // Define secondaryTextColor as a static constant for reusability
  static const Color secondaryTextColor = Colors.grey;

  const SearchAdmin({
    Key? key,
    this.hintText = 'Search...',
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        height: 40, // Set the height explicitly
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style:
              const TextStyle(color: Colors.black), // Text color set to black
          decoration: InputDecoration(
            filled: true, // Set filled to true for background color
            fillColor: Colors.white, // White background color
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey, // Hint text color
              fontSize: 14, // Reduced font size for the hint text
            ),
            prefixIcon:
                const Icon(Icons.search, color: Colors.grey), // Icon color
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8, // Adjusted vertical padding for reduced height
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: secondaryTextColor), // Default border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: secondaryTextColor), // Focused border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: secondaryTextColor), // Enabled border color
            ),
          ),
        ),
      ),
    );
  }
}
