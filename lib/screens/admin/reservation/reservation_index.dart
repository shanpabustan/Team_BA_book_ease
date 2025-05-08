import 'package:book_ease/screens/admin/reservation/reservation_table.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ReservationMain extends StatefulWidget {
  const ReservationMain({super.key});

  @override
  State<ReservationMain> createState() => _ReservationMainState();
}

class _ReservationMainState extends State<ReservationMain> {
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
            children: [
              // Reservation Table Section
              Expanded(
                child: ReservationTable(), // ReservationScreen widget
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example content inside ReservationScreen where all text should be Poppins
    return Column(
      children: [
        Text(
          'Reservation List',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // More text widgets using Poppins
        Text(
          'You can manage reservations here.',
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
