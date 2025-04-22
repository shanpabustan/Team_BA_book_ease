import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:book_ease/main.dart';

class NavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const NavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GNav(
        gap: 8,
        backgroundColor: Colors.white,
        color: Colors.grey[800], // Unselected icon color
        activeColor: Colors.white,
        tabBackgroundColor: secondaryColor, // Background color when selected
        padding: const EdgeInsets.all(16),
        tabs: const [
          GButton(
            icon: LineIcons.home,
            text: 'Home',
          ),
          GButton(
            icon: LineIcons.bookOpen,
            text: 'Library',
          ),
          GButton(
            icon: LineIcons.bookReader,
            text: 'My Books',
          ),
          GButton(
            icon: LineIcons.user,
            text: 'Account',
          ),
        ],
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
      ),
    );
  }
}
