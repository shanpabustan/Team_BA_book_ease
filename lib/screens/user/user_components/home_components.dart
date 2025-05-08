import 'dart:convert';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/user/home/see_all_screen.dart';
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
    final List<String> categories = [
      'All',
      'Information System',
    'Computer Science',
    'Engineering',
    'Mathematics',
    'Fiction',
    'Non-Fiction',
    'Textbooks',
    'Reference Materials',
    'Children’s Books',
    'Young Adult (YA)',
    'Science & Technology',
    'History & Social Studies',
    'Biographies',
    'Comics & Graphic Novels'
    ];

    return ValueListenableBuilder<String>(
      valueListenable: selectedCategory,
      builder: (context, value, _) {
        return SizedBox(
          height: 40,
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
                  foregroundColor: isSelected ? Colors.white : Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeeAllScreen(category: title),
                ),
              );
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
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: borrowedBooks.length,
          itemBuilder: (context, index) {
            final book = borrowedBooks[index];
            return Container(
              width: 100,
              margin: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 113,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
            );
          },
        ),
      );
    }

    final books = getBooks(category);

    if (books.isEmpty) {
      return const Text("No books available.");
    }

    return SizedBox(
      height: 150,
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
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 113,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            copies,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
