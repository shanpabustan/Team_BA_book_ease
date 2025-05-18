import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class FavouriteBooksScreen extends StatefulWidget {
  const FavouriteBooksScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteBooksScreen> createState() => _FavouriteBooksScreenState();
}

class _FavouriteBooksScreenState extends State<FavouriteBooksScreen> {
  final List<Map<String, String>> favouriteBooks = [
    {
      'title': 'Computer Programming Cyber Security',
      'author': 'Zach Codings',
      'category': 'Information System',
      'image': 'assets/images/percy-book.jpg',
      'dateAdded': '2025-05-13',
    },
    {
      'title': 'Computer Programming Cyber Security',
      'author': 'Zach Codings',
      'category': 'Information System',
      'image': 'assets/images/harry-book.jpg',
      'dateAdded': '2025-05-13',
    },
    {
      'title': 'Computer Programming Cyber Security',
      'author': 'Zach Codings',
      'category': 'Information System',
      'image': 'assets/images/percy-book.jpg',
      'dateAdded': '2025-05-13',
    },
    {
      'title': 'Computer Programming Cyber Security',
      'author': 'Zach Codings',
      'category': 'Information System',
      'image': 'assets/images/harry-book.jpg',
      'dateAdded': '2025-05-13',
    },
    {
      'title': 'Computer Programming Cyber Security',
      'author': 'Zach Codings',
      'category': 'Information System',
      'image': 'assets/images/percy-book.jpg',
      'dateAdded': '2025-05-13',
    },
    {
      'title': 'Computer Programming Cyber Security',
      'author': 'Zach Codings',
      'category': 'Information System',
      'image': 'assets/images/harry-book.jpg',
      'dateAdded': '2025-05-13',
    },
    {
      'title': 'Computer Programming Cyber Security',
      'author': 'Zach Codings',
      'category': 'Information System',
      'image': 'assets/images/percy-book.jpg',
      'dateAdded': '2025-05-13',
    },
    {
      'title': 'Computer Programming Cyber Security',
      'author': 'Zach Codings',
      'category': 'Information System',
      'image': 'assets/images/harry-book.jpg',
      'dateAdded': '2025-05-13',
    },
  ];

  void removeBook(int index) {
    setState(() {
      favouriteBooks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColor.lightGreenBackground,
      appBar: AppBar(
        backgroundColor: AdminColor.secondaryBackgroundColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white), // Change to white
        centerTitle: true,
        title: Text(
          "My Favourites",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white, // Change to white
          ),
        ),
      ),
      body: favouriteBooks.isEmpty
          ? Center(
              child: Text(
                "No favourite books yet.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                  16, 20, 16, 0), // Added top padding (20)
              itemCount: favouriteBooks.length,
              itemBuilder: (context, index) {
                final book = favouriteBooks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          book['image']!, // Use Image.asset for local assets
                          width: 60,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Book Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Delete Icon Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    book['title']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => removeBook(index),
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.red.shade700, // Dark red shade
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              book['author']!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              book['category']!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Inside the Column where the book details are shown
                            LayoutBuilder(
                              builder: (context, constraints) {
                                // Estimate if content will overflow
                                final isNarrow = constraints.maxWidth < 260;

                                return isNarrow
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date Added: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(book['dateAdded']!))}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          OutlinedButton(
                                            onPressed: () {
                                              // TODO: View details action
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Color(0xFF9AD3BC)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                            ),
                                            child: Text(
                                              "View details",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Color(0xFF2B4B50),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Date Added: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(book['dateAdded']!))}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          OutlinedButton(
                                            onPressed: () {
                                              // TODO: View details action
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Color(0xFF9AD3BC)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                            ),
                                            child: Text(
                                              "View details",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Color(0xFF2B4B50),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
