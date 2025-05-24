import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/user/app_text_styles.dart';

class BookDetailContent extends StatelessWidget {
  final dynamic book;
  final bool showReserveButton;
  final String? userId;
  final VoidCallback? onReserve;
  final bool showFavoriteButton;
  final bool isFavorited;
  final VoidCallback? onFavoriteToggle;

  const BookDetailContent({
    super.key,
    required this.book,
    this.showReserveButton = false,
    this.userId,
    this.onReserve,
    this.showFavoriteButton = false,
    this.isFavorited = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
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
              if (showFavoriteButton)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: AdminColor.secondaryBackgroundColor,
                    shape: const CircleBorder(),
                    elevation: 6,
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        size: 30,
                        color: isFavorited ? Colors.red : Colors.white,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
        _infoRowWithIcon(Icons.calendar_today, "Year Published", book.year),
        _infoRowWithIcon(Icons.book, "ISBN", book.isbn),
        _infoRowWithIcon(
            Icons.location_on, "Shelf Location", book.shelfLocation),
        _infoRowWithIcon(
            Icons.category, "Library Section", book.librarySection),
        _infoRowWithIcon(Icons.production_quantity_limits, "Available Copies",
            "${book.copies}"),
        if (showReserveButton && book.reserveCount != null)
          _infoRowWithIcon(
              Icons.bookmark, "Reserved Count", "${book.reserveCount}"),
        const SizedBox(height: 24),
        Text(
          "Description",
          style: GoogleFonts.poppins(
            fontWeight: AppTextStyles.sectionTitle.fontWeight,
            fontSize: AppTextStyles.sectionTitle.fontSize,
            color: Colors.grey.shade800,
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
        if (showReserveButton && onReserve != null) ...[
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onReserve,
                  label: Text(
                    "Reserve",
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColor.secondaryBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
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
