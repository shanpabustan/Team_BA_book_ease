import 'package:book_ease/screens/admin/components/reuse_dash_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dashboard_screen.dart';
import 'package:book_ease/services/analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  String selectedYear = DateTime.now().year.toString();
  final AnalyticsService _analyticsService = AnalyticsService();
  List<CategoryStats> _categoryStats = [];
  bool _isLoading = false;
  String? _error;

  // List of colors for different categories
  final List<Color> categoryColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lightBlue,
    // Add more colors if needed
  ];

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
  void initState() {
    super.initState();
    _fetchCategoryStats();
  }

  Future<void> _fetchCategoryStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final monthNumber = (months.indexOf(selectedMonth) + 1).toString();
      final stats = await _analyticsService.getMostBorrowedCategories(
        monthNumber,
        selectedYear,
      );
      setState(() {
        _categoryStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'There is no data for this month';
        _isLoading = false;
      });
    }
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
                            child: _buildDropdown(
                              selectedMonth,
                              months,
                              (newValue) {
                                setState(() => selectedMonth = newValue!);
                                _fetchCategoryStats();
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          SizedBox(
                            height: 40,
                            child: _buildDropdown(
                              selectedYear,
                              years,
                              (newValue) {
                                setState(() => selectedYear = newValue!);
                                _fetchCategoryStats();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : _error != null
                                ? Center(child: Text(_error!))
                                : _buildBarChart(),
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

  Widget _buildBarChart() {
    if (_categoryStats.isEmpty) {
      return Center(child: Text('No data available'));
    }

    final maxY = _categoryStats.map((s) => s.borrowCount).reduce((a, b) => a > b ? a : b).toDouble();

    return BarChart(
      BarChartData(
        maxY: maxY * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${_categoryStats[group.x].category}\n${rod.toY.round()} borrows',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
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
                if (value.toInt() >= 0 && value.toInt() < _categoryStats.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _categoryStats[value.toInt()].category,
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
        barGroups: _categoryStats.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.borrowCount.toDouble(),
                color: categoryColors[entry.key % categoryColors.length],
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
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