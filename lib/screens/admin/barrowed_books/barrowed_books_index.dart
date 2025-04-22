import 'package:book_ease/screens/admin/barrowed_books/barrowed_books_table.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class BorrowedBooksMain extends StatefulWidget {
  const BorrowedBooksMain({super.key});

  @override
  State<BorrowedBooksMain> createState() => _BorrowedBooksMainState();
}

class _BorrowedBooksMainState extends State<BorrowedBooksMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DashboardTheme.pageBackground,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Borrowed Books Table Section
              Expanded(
                child: BorrowedBooksTable(), // BorrowedBooksTable widget
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class BorrowedBooksScreen extends StatelessWidget {
  const BorrowedBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example content inside BorrowedBooksScreen where all text should be Poppins
    return Column(
      children: [
        Text(
          'Borrowed Books List',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // More text widgets using Poppins
        Text(
          'You can manage borrowed books here.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        // Add other widgets with Poppins font
      ],
    );
  }
}
