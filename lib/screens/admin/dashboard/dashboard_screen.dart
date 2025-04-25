import 'package:flutter/material.dart';
import '../components/sidebar.dart';
import '../components/adminapp_bar.dart';
import '../settings_folder/settings_index.dart';
import '../managebook/manage_books_index.dart';
import '../reservation/reservation_index.dart';
import '../usermanagement/manage_user_index.dart';
import '../barrowed_books/barrowed_books_index.dart';
import 'stats_section.dart';
import 'analytics.dart';
import 'most_borrowed.dart';

class DashboardTheme {
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.grey;
  static const Color cardBackground = Colors.white;
  static const Color pageBackground = Color.fromRGBO(248, 244, 243, 1.0);
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSidebarExpanded = true;
  int _selectedIndex = 0;

  void toggleSidebar() {
    setState(() => isSidebarExpanded = !isSidebarExpanded);
  }

  void _handleNavigation(int index) {
    setState(() => _selectedIndex = index);
  }

  final List<String> _titles = [
    "Welcome to the Admin Dashboard",
    "Manage Books",
    "Manage Users",
    "Reservation Overview",
    "Borrowed Books",
    "Settings",
  ];

  final List<Widget> _contentScreens = [
    DashboardContent(),
    ManageBook(),
    ManageUser(),
    ReservationMain(),
    BorrowedBooksMain(),
    SettingsMain(),
  ];

  List<Widget> get _screensWithAppBar =>
      List.generate(_contentScreens.length, (index) {
        return Container(
          color: DashboardTheme.pageBackground,
          child: Column(
            children: [
              AppBarWidget(
                scaffoldKey: _scaffoldKey,
                title: _titles[index],
              ),
              Expanded(child: _contentScreens[index]),
            ],
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DashboardTheme.pageBackground,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800)
            Sidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: _handleNavigation,
            ),
          Expanded(child: _screensWithAppBar[_selectedIndex]),
        ],
      ),
    );
  }
}

// DashboardContent remains for main dashboard screen (index 0)
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatsSection(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: AnalyticsScreen()),
                MostBorrowedBooks(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
