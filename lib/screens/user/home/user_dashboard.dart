import 'package:book_ease/screens/user/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/widgets/bottomusernav_widget.dart';
import 'package:book_ease/screens/user/library/library_main.dart';
import 'package:book_ease/screens/user/my_books/mybooks_main.dart';
import 'package:book_ease/screens/user/account/account_main.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const UserDashApp());
}

class UserDashApp extends StatefulWidget {
  const UserDashApp({super.key});

  @override
  _UserDashAppState createState() => _UserDashAppState();
}

// ===================== Bottom Navigation =====================
class _UserDashAppState extends State<UserDashApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const LibraryScreen(),
    const MyBooksScreen(),
    const AccountScreen(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBarWidget(
          selectedIndex: _selectedIndex,
          onTabChange: _onTabChange,
        ),
      ),
    );
  }
}
