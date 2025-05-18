import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/admin_theme.dart'; // Ensure you have AdminColor imported
import 'package:book_ease/screens/user/app_text_styles.dart';

class BookDetailScreen extends StatelessWidget {
  final dynamic book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(book.image.split(',').last),
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: GoogleFonts.poppins(
                    fontSize: AppTextStyles.pageTitle.fontSize,
                    fontWeight: AppTextStyles.pageTitle.fontWeight,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _infoRowWithIcon(Icons.person, "Author", book.author),
                _infoRowWithIcon(
                    Icons.calendar_today, "Year Published", book.year),
                _infoRowWithIcon(Icons.book, "ISBN", book.isbn),
                _infoRowWithIcon(
                    Icons.location_on, "Shelf Location", book.shelfLocation),
                _infoRowWithIcon(
                    Icons.category, "Library Section", book.librarySection),
                _infoRowWithIcon(Icons.production_quantity_limits,
                    "Available Copies", "${book.copies}"),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description",
                style: GoogleFonts.poppins(
                  fontWeight: AppTextStyles.sectionTitle.fontWeight,
                  fontSize: AppTextStyles.sectionTitle.fontSize,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.description ?? "No description available.",
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: AppTextStyles.body.fontSize,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRowWithIcon(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AdminColor.secondaryBackgroundColor),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: AppTextStyles.body.fontSize,
                ),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: AppTextStyles.body.fontSize,
                    ),
                  ),
                  TextSpan(
                    text: value ?? "N/A",
                    style: GoogleFonts.poppins(
                        fontSize: AppTextStyles.body.fontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showBookDetailModal(BuildContext context, dynamic book) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors
        .transparent, // Important to keep transparent to allow rounded corners
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white, // Set white background here
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BookDetailScreen(book: book),
    ),
  );
}
