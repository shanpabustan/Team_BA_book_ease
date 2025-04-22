import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:book_ease/modals/logout_modal.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

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
        onLogout: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged out successfully.")),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    final isHovered = _hoverIndex == index;
    final isSelected = widget.selectedIndex == index;
    final showText = _isHovered;

    // Default color when not hovered
    Color iconColor = Color.fromRGBO(212, 216, 220, 1); // #9AA6B2
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
                        style: TextStyle(
                          fontSize: 14,
                          color: iconColor, // Same color as the icon
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
    final sidebarWidth =
        _isHovered ? 218.0 : 70.0; // Adjusted to prevent overflow

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
          _buildMenuItem(Icons.calendar_today, 'Calendar', 4),
          _buildMenuItem(Icons.bookmark, 'Borrowed Books', 5),
        ],
      ),
    );
  }
}
