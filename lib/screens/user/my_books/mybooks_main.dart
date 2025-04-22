import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:book_ease/widgets/bottomusernav_widget.dart';
import 'package:book_ease/main.dart';

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text("My Books"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "My Books Screen",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Function to handle navigation
  // ignore: unused_element
  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/library');
        break;
      case 2:
        // Already on My Books, do nothing
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}
