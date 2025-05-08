import 'package:book_ease/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:book_ease/modals/logout_modal.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/screens/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _hoverIndex = -1;
  bool _isHovered = false;

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => LogoutModal(
      onCancel: () => Navigator.pop(context),
      onLogout: () async {
        Navigator.pop(context); // Close the modal first

        try {
          final dio = Dio();
          final response = await dio.post(
            '${ApiConfig.baseUrl}/stud/logout', // Replace with your actual backend URL
            options: Options(
              headers: {
                'Content-Type': 'application/json',
              },
            ),
          );

          if (response.statusCode == 200 && response.data['retCode'] == '200') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Logged out successfully.",
                  style: GoogleFonts.poppins(),
                ),
              ),
            );

            // Clear the shared preferences for login state and user type
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('isLoggedIn');
            await prefs.remove('userType');

            // Redirect to login screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LogBookEaseApp(),
              ),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Logout failed.")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logout error: $e")),
          );
        }
      },
    ),
  );
}

  Widget _buildMenuItem(IconData icon, String title, int index) {
    final isHovered = _hoverIndex == index;
    final isSelected = widget.selectedIndex == index;
    final showText = _isHovered;

    Color iconColor = const Color.fromRGBO(212, 216, 220, 1); // Default color
    if (isHovered || isSelected) {
      iconColor = Colors.white;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hoverIndex = index),
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: GestureDetector(
        onTap: () {
          if (index == 99) {
            showLogoutDialog(context);
          } else {
            widget.onItemSelected(index);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          child: GlowContainer(
            glowColor: isSelected
                ? AdminColor.secondaryBackgroundColor
                : Colors.transparent,
            blurRadius: isSelected ? 10 : 0,
            borderRadius: BorderRadius.circular(8.0),
            color: isSelected
                ? AdminColor.secondaryBackgroundColor
                : Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: isHovered || isSelected
                    ? AdminColor.secondaryBackgroundColor
                    : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(icon, size: 24, color: iconColor),
                  const SizedBox(width: 10),
                  if (showText)
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: iconColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sidebarWidth = _isHovered ? 218.0 : 70.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: sidebarWidth,
        color: AdminColor.sidebarBackgroundColor,
        child: Column(
          children: [
            _buildHeader(),
            _buildMenuItems(),
            _buildMenuItem(Icons.logout, 'Logout', 99),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isHovered ? 80 : 50,
          height: _isHovered ? 80 : 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/admin_logo_white.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildMenuItem(Icons.dashboard, 'Dashboard', 0),
          _buildMenuItem(Icons.menu_book, 'Manage Books', 1),
          _buildMenuItem(Icons.people, 'User Management', 2),
          _buildMenuItem(Icons.event, 'Reservations', 3),
          _buildMenuItem(Icons.bookmark, 'Borrowed Books', 4),
          _buildMenuItem(Icons.settings, 'Settings', 5),
        ],
      ),
    );
  }
}
