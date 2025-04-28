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

  // Get the color and label for the badge based on the rank
  int getBadgeLabel(int rank) {
    switch (rank) {
      case 0:
        return 1; // Return 1 for first rank
      case 1:
        return 2; // Return 2 for second rank
      case 2:
        return 3; // Return 3 for third rank
      default:
        return rank +
            1; // For books not in the top 3, return the rank number (rank starts from 0, so adding 1 makes it a natural ranking)
    }
  }

  Color getBadgeColor(int rank) {
    switch (rank) {
      case 0:
        return Colors.amber; // Gold
      case 1:
        return Colors.grey; // Silver
      case 2:
        return Colors.brown; // Bronze
      default:
        return Colors.blueGrey; // Default color for other ranks
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0, bottom: 20.0), // External top & bottom padding
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: DashboardTheme.cardBackground,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 30, horizontal: 30), // Inner padding
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
                              // Badge before the image
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getBadgeColor(entry
                                      .key), // Gold, Silver, Bronze, or Default
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  getBadgeLabel(entry.key)
                                      .toString(), // Convert int to string for displaying
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              // Image with design
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  entry.value['image']!,
                                  width: 50, // Adjust width as needed
                                  height: 60, // Adjust height as needed
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              // Book Title
                              Text(
                                entry.value['title']!,
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
      ),
    );
  }
}
