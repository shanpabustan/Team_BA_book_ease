import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Mock data for book categories borrowing
class TopBookCategoryBorrowData {
  static const List<String> categoryLabels = [
    'Fiction',
    'Science',
    'Mathematics',
    'History',
    'Literature',
    'Art'
  ];

  // This function will generate category data dynamically based on the month and year
  static List<double> getCategoryValues(String month, String year) {
    // Generate dummy data based on selected month and year
    int monthIndex = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ].indexOf(month);

    // Just to demonstrate dynamic changes, we'll tweak the data based on the selected month and year
    List<double> categoryValues = [
      500 + monthIndex * 20, // Fiction
      750 + monthIndex * 30, // Science
      900 + monthIndex * 25, // Mathematics
      650 + monthIndex * 15, // History
      400 + monthIndex * 10, // Literature
      800 + monthIndex * 20, // Art
    ];

    // Random adjustments based on year (for demonstration purposes)
    if (year == '2025') {
      categoryValues = categoryValues.map((val) => val + 100).toList();
    } else if (year == '2024') {
      categoryValues = categoryValues.map((val) => val - 50).toList();
    }

    return categoryValues;
  }

  // Function to generate the bar chart data dynamically for each category
  static List<BarChartGroupData> getCategoryData(String month, String year) {
    List<BarChartGroupData> barGroups = [];
    List<double> categoryValues = getCategoryValues(month, year);

    // Loop through the category labels and values to create bar chart data
    for (int i = 0; i < categoryLabels.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: categoryValues[i],
              width: 20,
              color: _getCategoryColor(i),
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  // Function to dynamically assign colors to bars based on the index
  static Color _getCategoryColor(int index) {
    List<Color> barColors = [
      const Color.fromARGB(255, 34, 136, 219),
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.cyan,
    ];

    return barColors[index % barColors.length]; // Cycle through colors
  }
}
