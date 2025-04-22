import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/widgets/search_widget.dart';
import 'package:book_ease/main.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationPressed;

  const AppBarWidget({
    super.key,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: secondaryColor,
      title: Row(
        children: [
          // Image.asset(
          //   'assets/images/admin_logo.png', // ✅ Add your logo image
          //   height: 100,
          // ),
          Text(
            "BookEase",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: onNotificationPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
