// user_dash_app.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/user/home/home_screen.dart';
import 'package:book_ease/screens/user/library/library_main.dart';
import 'package:book_ease/screens/user/my_books/mybooks_main.dart';
import 'package:book_ease/screens/user/account/account_main.dart';
import 'package:book_ease/widgets/bottomusernav_widget.dart';

void main() {
  runApp(const UserDashApp());
}

class UserDashApp extends StatefulWidget {
  const UserDashApp({super.key});

  @override
  _UserDashAppState createState() => _UserDashAppState();
}

class _UserDashAppState extends State<UserDashApp> {
  int _selectedIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const SizedBox(), // Placeholder for HomeScreen
      const LibraryScreen(),
      const MyBooksScreen(),
      const AccountScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: Scaffold(
        body: _selectedIndex == 0 
          ? HomeScreen(onReserveTap: () => _onTabChange(1))
          : _pages[_selectedIndex],
        bottomNavigationBar: NavigationBarWidget(
          selectedIndex: _selectedIndex,
          onTabChange: _onTabChange,
        ),
      ),
    );
  }
}
