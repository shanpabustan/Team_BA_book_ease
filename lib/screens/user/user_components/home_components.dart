import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/user/home/book_details_modal.dart';
import 'package:book_ease/screens/user/home/see_all_screen.dart';
import 'package:book_ease/screens/user/user_components/book_detail_helper.dart';
import 'package:book_ease/utils/navigator_helper.dart';
//import 'package:book_ease/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UIComponents {
  static Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget selectCategory(ValueNotifier<String> selectedCategory) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final categories = bookProvider.categories;

        return ValueListenableBuilder<String>(
          valueListenable: selectedCategory,
          builder: (context, value, _) {
            return SizedBox(
              height: 35,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = value == category;

                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isSelected
                          ? AdminColor.secondaryBackgroundColor
                          : Colors.grey[200],
                      foregroundColor:
                          isSelected ? Colors.white : Colors.black87,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => selectedCategory.value = category,
                    child: Text(
                      category,
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  static Widget bookSection(BuildContext context, String category,
      List<Map<String, String>> Function(String) getBooks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, category),
        _bookList(context, category, getBooks),
      ],
    );
  }

  static Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              fadePush(context, SeeAllScreen(category: title));
            },
            child: Text(
              'See All',
              style: GoogleFonts.poppins(color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _bookList(BuildContext context, String category,
      List<Map<String, String>> Function(String) getBooks) {
    final bookProvider = Provider.of<BookProvider>(context);

    if (category == 'Borrowed Books') {
      final borrowedBooks = bookProvider.borrowedBooks;

      if (borrowedBooks.isEmpty) {
        return const Text("No borrowed books.");
      }

      return SizedBox(
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: borrowedBooks.length,
          itemBuilder: (context, index) {
            final book = borrowedBooks[index];
            return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => showBookDetailModal(context, book),
                  borderRadius: BorderRadius.circular(
                      8), // Optional: Matches the image rounding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: MemoryImage(base64Decode(book.image)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Due: ${book.dueDate.split('T').first}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ),
      );
    }

    final books = getBooks(category);

    if (books.isEmpty) {
      return const Text("No books available.");
    }

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _bookTile(book["title"]!, book["copies"]!, book["image"]!);
        },
      ),
    );
  }

  static Widget _bookTile(String title, String copies, String imagePath) {
    print('\nBuilding book tile for: $title');
    print('Image path type: ${imagePath.startsWith('assets/') ? 'asset' : 'base64'}');
    
    if (!imagePath.startsWith('assets/')) {
      print('Base64 image length: ${imagePath.length}');
      print('Base64 image data: ${imagePath.substring(0, min(50, imagePath.length))}...');
    }

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 100,
              height: 130,
              color: Colors.grey[200],
              child: imagePath.startsWith('assets/')
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading asset image: $error');
                        return const Center(
                          child: Icon(Icons.book, color: Colors.grey),
                        );
                      },
                    )
                  : Builder(
                      builder: (context) {
                        try {
                          print('Attempting to decode base64 image');
                          
                          // Clean the base64 string if it contains the data URI prefix
                          String cleanBase64 = imagePath;
                          if (imagePath.contains('base64,')) {
                            cleanBase64 = imagePath.split('base64,').last;
                          }
                          
                          print('Cleaned base64 string length: ${cleanBase64.length}');
                          final Uint8List bytes = base64Decode(cleanBase64);
                          print('Successfully decoded base64 data, bytes length: ${bytes.length}');
                          
                          return Image.memory(
                            bytes,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading base64 image: $error');
                              print('Stack trace: $stackTrace');
                              return const Center(
                                child: Icon(Icons.book, color: Colors.grey),
                              );
                            },
                          );
                        } catch (e) {
                          print('Error decoding base64 image: $e');
                          print('Problematic image data: ${imagePath.substring(0, min(50, imagePath.length))}...');
                          return const Center(
                            child: Icon(Icons.book, color: Colors.grey),
                          );
                        }
                      },
                    ),
            ),
          ),
          const SizedBox(height: 5),

          // Title Text
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            copies,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  static void showBookDetailModal(BuildContext context, dynamic book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Required for full height
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  BookDetailContent(
                    book: book,
                    showReserveButton: false,
                    showFavoriteButton: false,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
