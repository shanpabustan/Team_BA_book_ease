import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Import the theme from the existing file

class MostBorrowedBooks extends StatelessWidget {
  final List<Map<String, String>> books = [
    {
      'title': 'Intermediate Accounting',
      'image': 'assets/images/percy-book.jpg'
    },
    {'title': 'JAVA Programming', 'image': 'assets/images/percy-book.jpg'},
    {
      'title': 'The Business of Tourism',
      'image': 'assets/images/percy-book.jpg'
    },
    {'title': 'Python Programming', 'image': 'assets/images/percy-book.jpg'},
    {
      'title': 'Artificial Intelligence Basics',
      'image': 'assets/images/percy-book.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: DashboardTheme.cardBackground,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Borrowed Books',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DashboardTheme.primaryTextColor,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: books
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            // Image with design
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                              child: Image.asset(
                                entry.value['image']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 15),
                            // Book Title
                            Text(
                              '${entry.key + 1}. ${entry.value['title']}', // Auto-numbering
                              style: TextStyle(
                                fontSize: 16,
                                color: DashboardTheme.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}