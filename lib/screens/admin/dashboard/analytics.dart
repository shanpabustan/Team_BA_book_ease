import 'package:book_ease/screens/admin/components/reuse_dash_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../mock_data/bargraph_data.dart';
import 'package:intl/intl.dart';
import 'dashboard_screen.dart'; // For DashboardTheme

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  String selectedYear = DateTime.now().year.toString();

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

  List<String> get years {
    int currentYear = DateTime.now().year;
    return List.generate(6, (index) => (currentYear - index).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              Expanded(
                child: ReusableDashboardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and dropdowns
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Most Borrowed Book Categories\n$selectedMonth $selectedYear',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: DashboardTheme.primaryTextColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          SizedBox(
                            height: 40,
                            child: _buildDropdown(selectedMonth, months,
                                (newValue) {
                              setState(() => selectedMonth = newValue!);
                            }),
                          ),
                          SizedBox(width: 12),
                          SizedBox(
                            height: 40,
                            child:
                                _buildDropdown(selectedYear, years, (newValue) {
                              setState(() => selectedYear = newValue!);
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            maxY: 1000,
                            barTouchData: BarTouchData(enabled: true),
                            alignment: BarChartAlignment.spaceAround,
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 35,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toInt().toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 &&
                                        value.toInt() <
                                            TopBookCategoryBorrowData
                                                .categoryLabels.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          TopBookCategoryBorrowData
                                              .categoryLabels[value.toInt()],
                                          style: TextStyle(fontSize: 10),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            barGroups:
                                TopBookCategoryBorrowData.getCategoryData(
                              selectedMonth,
                              selectedYear,
                            ).map((group) {
                              return BarChartGroupData(
                                x: group.x,
                                barRods: group.barRods,
                                barsSpace: 6,
                              );
                            }).toList(),
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
    );
  }

  Widget _buildDropdown(
    String selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          onChanged: onChanged,
          icon: Icon(Icons.arrow_drop_down),
          style: TextStyle(fontSize: 14, color: Colors.black),
          dropdownColor: Colors.white,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}