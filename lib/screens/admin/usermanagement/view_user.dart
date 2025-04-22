import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class ViewUserModal extends StatelessWidget {
  final Map<String, String> user;
  const ViewUserModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Row with Title centered and Close button on the right
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'User Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        padding: EdgeInsets.zero, // Remove extra padding
                        constraints:
                            const BoxConstraints(), // Remove default IconButton constraints
                        icon: CircleAvatar(
                          radius: 14, // Smaller radius (default is 20)
                          backgroundColor: AdminColor
                              .secondaryBackgroundColor, // Change to your desired color
                          child: const Icon(Icons.close,
                              size: 16,
                              color: Colors.white), // Smaller icon size
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
               const SizedBox(height: 24),
              _buildTextField(label: 'User ID', value: user['userId'] ?? ''),
              _buildTextField(label: 'Full Name', value: user['name'] ?? ''),
              _buildTextField(label: 'Phone Number', value: user['phoneNumber'] ?? ''),
              _buildTextField(label: 'Email', value: user['email'] ?? ''),
              _buildTextField(label: 'Year Level', value: user['yearLevel'] ?? ''),
              _buildTextField(label: 'Course', value: user['course'] ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: AdminColor.secondaryBackgroundColor, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
