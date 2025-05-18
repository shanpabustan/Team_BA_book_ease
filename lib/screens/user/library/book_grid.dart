import 'dart:convert';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/screens/user/app_text_styles.dart';
import 'package:book_ease/screens/user/library/book_tile.dart';
import 'package:book_ease/screens/user/library/reservation_modal.dart';
import 'package:book_ease/screens/user/my_books/add_to_my_books.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class BookGrid extends StatelessWidget {
  final String userId;

  const BookGrid({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.books;
    final isLoading = bookProvider.isLoading;

    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 5;
    } else if (screenWidth >= 900) {
      crossAxisCount = 4;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: books.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () => _showBookDetails(context, book, userId),
          child: BookItem(book: book),
        );
      },
    );
  }

  void _showBookDetails(BuildContext context, dynamic book, String userId) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isMobile = screenWidth < 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        bool isFavorited = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: screenHeight,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // X close button on the left
                          Material(
                            color:
                                Colors.grey.shade200, // light background color
                            shape: const CircleBorder(),
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 30),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: 'Close',
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Image with favorite button inside a Stack, centered horizontally
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Stack(
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
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Material(
                                      color:
                                          AdminColor.secondaryBackgroundColor,
                                      shape: const CircleBorder(),
                                      elevation: 6,
                                      shadowColor: Colors.white,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 30,
                                          color: isFavorited
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isFavorited = !isFavorited;
                                          });

                                          if (isFavorited) {
                                            addToMyBooks(context, book.title);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // To keep image truly centered visually, add right-side spacer matching IconButton width
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: GoogleFonts.poppins(
                              fontSize: isMobile
                                  ? AppTextStyles.pageTitle.fontSize
                                  : AppTextStyles.pageTitle.fontSize,
                              fontWeight: AppTextStyles.pageTitle.fontWeight,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _infoRowWithIcon(Icons.person, "Author", book.author),
                          _infoRowWithIcon(Icons.calendar_today,
                              "Year Published", book.year),
                          _infoRowWithIcon(Icons.book, "ISBN", book.isbn),
                          _infoRowWithIcon(Icons.location_on, "Shelf Location",
                              book.shelfLocation),
                          _infoRowWithIcon(Icons.category, "Library Section",
                              book.librarySection),
                          _infoRowWithIcon(Icons.production_quantity_limits,
                              "Available Copies", "${book.copies}"),
                          _infoRowWithIcon(Icons.bookmark, "Reserved Count",
                              "${book.reserveCount}"),
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
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showReservationModal(
                                  context,
                                  book.title,
                                  book.copies,
                                  book.bookId,
                                  userId,
                                );
                              },
                              label: Text(
                                "Reserve",
                                style: AppTextStyles.button
                                    .copyWith(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AdminColor.secondaryBackgroundColor,
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
                  ),
                ),
              ),
            );
          },
        );
      },
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
                      fontSize: AppTextStyles.body.fontSize,
                    ),
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
