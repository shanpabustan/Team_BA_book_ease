import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Your DashboardTheme
import 'package:book_ease/screens/admin/admin_theme.dart';

class MostBorrowedBooks extends StatefulWidget {
  @override
  _MostBorrowedBooksState createState() => _MostBorrowedBooksState();
}

class _MostBorrowedBooksState extends State<MostBorrowedBooks> {
  final List<Map<String, String>> books = [
    {'title': 'Intermediate Accounting', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'JAVA Programming', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'The Business of Tourism', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'Python Programming', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'Artificial Intelligence Basics', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'Software Engineering', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'Database Systems', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'Modern Operating Systems', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'Computer Networks', 'image': 'assets/images/percy-book.jpg'},
    {'title': 'Cloud Computing', 'image': 'assets/images/percy-book.jpg'},
  ];

  int displayedCount = 5;

  int getBadgeLabel(int rank) => rank + 1;

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
                // Header
                Text(
                  'Most Borrowed Books',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DashboardTheme.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Book list
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...books
                            .take(displayedCount)
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                // Badge
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
                                
                                // Book image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    entry.value['image']!,
                                    width: 50,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                
                                // Book title
                                Expanded(
                                  child: Text(
                                    entry.value['title']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: DashboardTheme.secondaryTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        
                        const SizedBox(height: 20),
                        
                        // Show more button
                        if (displayedCount < books.length)
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  displayedCount = (displayedCount + 5).clamp(0, books.length);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DashboardTheme.primaryColor,
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
