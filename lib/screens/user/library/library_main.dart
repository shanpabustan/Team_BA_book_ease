import 'dart:convert';
import 'package:book_ease/main.dart';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/screens/user/library/reservation_modal.dart';
import 'package:book_ease/screens/user/my_books/add_to_my_books.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false).fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bookProvider = Provider.of<BookProvider>(context);
    final userId = Provider.of<UserData>(context).userID; // FETCHED USER ID HERE
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text(
          "Library",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  final book = books[index];
                  return GestureDetector(
                    onTap: () => _showBookDetails(context, book, userId), // PASSED USER ID TO MODAL
                    child: BookTile(
                      title: book.title,
                      author: book.author,
                      base64Image: book.image,
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: NavigationBarWidget(
        selectedIndex: 1,
        onTabChange: (index) => _navigateToScreen(context, index),
      ),
    );
  }

  // UPDATED METHOD SIGNATURE TO ACCEPT USER ID
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
          heightFactor: 0.7,
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
                          height: screenHeight * 0.3,
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
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(height: 16),
                            _infoRow("Author", book.author, fontSize: 15),
                            _infoRow("Year Published", book.year, fontSize: 15),
                            _infoRow("ISBN", book.isbn, fontSize: 15),
                            _infoRow("Shelf Location", book.shelfLocation, fontSize: 15),
                            _infoRow("Library Section", book.librarySection, fontSize: 15),
                            _infoRow("Available Copies", "${book.copies}", fontSize: 15),
                            _infoRow("Reserved Count", "${book.reserveCount}", fontSize: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                      book.bookId, // Pass bookId here
                      userId, // Pass userId here
                    );

                        },
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text("Reserve", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          addToMyBooks(context, book.title);
                        },
                        icon: const Icon(Icons.bookmark, color: Colors.white),
                        label: const Text("Add to My Books", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
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

  Widget _infoRow(String label, String? value, {double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/mybooks');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  NavigationBarWidget({required int selectedIndex, required void Function(dynamic index) onTabChange}) {}
}

class BookTile extends StatelessWidget {
  final String title;
  final String author;
  final String base64Image;

  const BookTile({
    super.key,
    required this.title,
    required this.author,
    required this.base64Image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(
                  base64Decode(base64Image.split(',').last),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              author,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
