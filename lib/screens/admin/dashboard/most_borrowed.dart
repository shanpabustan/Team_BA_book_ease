import 'package:book_ease/widgets/svg_loading_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Your DashboardTheme
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/services/book_service.dart';
import 'package:book_ease/models/book_borrow_count.dart';

class MostBorrowedBooks extends StatefulWidget {
  @override
  _MostBorrowedBooksState createState() => _MostBorrowedBooksState();
}

class _MostBorrowedBooksState extends State<MostBorrowedBooks> {
  List<BookBorrowCount>? books;
  String? error;
  bool isLoading = true;
  int displayedCount = 5;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final fetchedBooks = await BookService.getMostBorrowedBooks();
      setState(() {
        books = fetchedBooks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Color getBadgeColor(int rank) {
    switch (rank) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return Colors.blueGrey;
    }
  }

  int getBadgeLabel(int rank) => rank + 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: DashboardTheme.cardBackground,
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Most Borrowed Books',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  const SizedBox(
                    height: 350,
                    child: Center(child: SvgLoadingScreen()),
                  )
                else if (error != null)
                  Center(
                    child: Text(
                      'Error: $error',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                else if (books?.isEmpty ?? true)
                  const Center(
                    child: Text('No borrowed books found for this period'),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...books!
                              .take(displayedCount)
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                            final book = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: getBadgeColor(entry.key),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      getBadgeLabel(entry.key).toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: book.getImageWidget(
                                      width: 50,
                                      height: 65,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${book.borrowCount} times borrowed',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          if (books!.length > displayedCount) ...[
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    displayedCount = (displayedCount + 5)
                                        .clamp(0, books!.length);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AdminColor.secondaryBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Show More',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
