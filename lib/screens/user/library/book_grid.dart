import 'dart:convert';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/screens/user/library/book_tile.dart';
import 'package:book_ease/screens/user/library/reservation_modal.dart';
import 'package:book_ease/screens/user/my_books/add_to_my_books.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Increased the height factor to make it larger
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          base64Decode(book.image.split(',').last),
                          height: screenHeight * 0.4, // Increased image height
                          width: screenWidth * 0.35,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                book.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Title color
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _infoRow("Author", book.author),
                            _infoRow("Year Published", book.year),
                            _infoRow("ISBN", book.isbn),
                            _infoRow("Shelf Location", book.shelfLocation),
                            _infoRow("Library Section", book.librarySection),
                            _infoRow("Available Copies", "${book.copies}"),
                            _infoRow("Reserved Count", "${book.reserveCount}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(book.description),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showReservationModal(
                            context,
                            book.title,
                            book.copies,
                            book.bookId,
                            userId,
                          );
                        },
                        icon: const Icon(Icons.check,
                            color: Colors.white), // White icon
                        label: const Text("Reserve",
                            style:
                                TextStyle(color: Colors.white)), // White text
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Border radius set to 8
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14), // Adjusted top/bottom padding
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600), // Text styling
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          addToMyBooks(context, book.title);
                        },
                        icon: const Icon(Icons.bookmark_add,
                            color: Colors
                                .white), // Related icon for adding to books
                        label: const Text("Add to My Books",
                            style:
                                TextStyle(color: Colors.white)), // White text
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Border radius set to 8
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14), // Adjusted top/bottom padding
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600), // Text styling
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
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
