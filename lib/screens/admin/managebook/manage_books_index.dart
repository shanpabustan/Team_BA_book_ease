import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:book_ease/screens/admin/managebook/book_management_table.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageBook extends StatefulWidget {
  const ManageBook({super.key});

  @override
  State<ManageBook> createState() => _ManageBookState();
}

class _ManageBookState extends State<ManageBook> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DashboardTheme.pageBackground,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // Book Management Table Section
              Expanded(
                child: BookManagementApp(), // BookManagementScreen widget
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class BookManagementScreen extends StatelessWidget {
  const BookManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Books',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You can manage the book records here.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        // Add other Poppins-styled widgets as needed
      ],
    );
  }
}
