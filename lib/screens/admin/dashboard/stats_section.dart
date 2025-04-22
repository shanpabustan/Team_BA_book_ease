// stats_section.dart
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart'; // Adjust this import based on your file structure

class StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StatCard(
              title: 'Registered Users',
              value: '1030',
              icon: Icons.person,
              borderColor: Colors.blueAccent,
              iconBgColor: Colors.blue[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Borrowed Books',
              value: '3054',
              icon: Icons.book,
              borderColor: Colors.greenAccent,
              iconBgColor: Colors.green[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Reservations',
              value: '2051',
              icon: Icons.event,
              borderColor: Colors.orangeAccent,
              iconBgColor: Colors.orange[200]!,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: StatCard(
              title: 'Overdue Books',
              value: '20',
              icon: Icons.warning,
              borderColor: Colors.redAccent,
              iconBgColor: Colors.red[200]!,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color borderColor;
  final Color iconBgColor;

  StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.borderColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: DashboardTheme.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: borderColor, width: 5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: DashboardTheme.primaryTextColor,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: DashboardTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}