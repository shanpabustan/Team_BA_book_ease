import 'dart:convert'; // Import this for base64 decoding
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class ViewBookModal extends StatelessWidget {
  final Map<String, String> book;
  const ViewBookModal({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header / AppBar Style
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: AdminColor.secondaryBackgroundColor,
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Book Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: AdminFontSize.heading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for center alignment
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((book['image'] ?? '').isNotEmpty)
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildImage(book['image']!),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          _buildTextField(
                              label: 'Category', value: book['category'] ?? ''),
                          _buildTextField(
                              label: 'Condition',
                              value: book['condition'] ?? ''),
                          const SizedBox(height: 16),

                          // Description with auto-height
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    book['description'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                    softWrap: true,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Right Column
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Information',
                              style: TextStyle(
                                fontSize: AdminFontSize.subHeading,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                                label: 'Book ID', value: book['bookId'] ?? ''),
                            _buildTextField(
                                label: 'Title', value: book['title'] ?? ''),
                            _buildTextField(
                                label: 'Author', value: book['author'] ?? ''),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Year Published',
                                    value: book['year'] ?? '',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Version',
                                    value: book['version'] ?? '',
                                  ),
                                ),
                              ],
                            ),
                            _buildTextField(
                                label: 'ISBN', value: book['isbn'] ?? ''),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Available Copies',
                                    value: book['copies'] ?? '',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Section',
                                    value: book['section'] ?? '',
                                  ),
                                ),
                              ],
                            ),
                            _buildTextField(
                                label: 'Shelf Location',
                                value: book['shelfLocation'] ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Decode base64 and display the image
  Widget _buildImage(String base64Image) {
    try {
      final bytes = base64Decode(base64Image.split(',').last);
      return Image.memory(bytes, height: 200, fit: BoxFit.contain);
    } catch (e) {
      return const Text("Image not found");
    }
  }
}

Widget _buildTextField({required String label, required String value}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // <- Set label color to black
          ),
        ),
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
              borderSide:
                  const BorderSide(color: AdminColor.secondaryBackgroundColor),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
