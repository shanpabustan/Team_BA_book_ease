import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../mock_data/bargraph_data.dart';
import 'package:intl/intl.dart'; // For getting the current year dynamically

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedMonth =
      DateFormat('MMMM').format(DateTime.now()); // Default to current month
  String selectedYear =
      DateTime.now().year.toString(); // Default to current year

  final List<String> months = [
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
  ];

  // Generate dynamic list of years (past 5 years + current year)
  List<String> get years {
    int currentYear = DateTime.now().year;
    return List.generate(6, (index) => (currentYear - index).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Month & Year in the same row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  'Most Borrowed Book Categories - $selectedMonth $selectedYear',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black, // Ensure text is visible
                  ),
                ),

                // Month & Year dropdowns
                Row(
                  children: [
                    _buildDropdown(selectedMonth, months, (newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                      });
                    }),
                    SizedBox(width: 8), // Spacing between dropdowns
                    _buildDropdown(selectedYear, years, (newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    }),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            // Graph Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(enabled: true),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 1000,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() <
                                    TopBookCategoryBorrowData
                                        .categoryLabels.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  TopBookCategoryBorrowData
                                      .categoryLabels[value.toInt()],
                                  style: TextStyle(
                                    color: Colors
                                        .black, // Ensure labels are visible
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barGroups: TopBookCategoryBorrowData.getCategoryData(
                        selectedMonth, selectedYear),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Compact Dropdown Builder
  Widget _buildDropdown(String selectedValue, List<String> options,
      ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          onChanged: onChanged,
          dropdownColor:
              Colors.white, // Ensure dropdown has a visible background
          style: TextStyle(
              color: Colors.black, fontSize: 14), // Make dropdown text black
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option,
                  style:
                      TextStyle(color: Colors.black)), // Ensure items are black
            );
          }).toList(),
        ),
      ),
    );
  }
}