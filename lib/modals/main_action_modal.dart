import 'package:flutter/material.dart';

class CustomActionModal extends StatelessWidget {
  final String title;
  final String message;
  final String iconPath; // Path for the icon in the modal
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String confirmButtonText;
  final String cancelButtonText;
  final Color buttonColor;
  final Color borderColor;
  final IconData iconData;
  final Color iconColor;

  const CustomActionModal({
    super.key,
    required this.title,
    required this.message,
    required this.iconPath,
    required this.onCancel,
    required this.onConfirm,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.buttonColor,
    required this.borderColor,
    required this.iconData,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400, // Set a maximum width for the modal
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C0E4B), // dark purple
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Icon + Text for action
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconData,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 12),

              // Buttons
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        cancelButtonText,
                        style: TextStyle(
                          color: borderColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onConfirm();
                        Navigator.pop(
                            context); // Close the modal after confirm action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        confirmButtonText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
