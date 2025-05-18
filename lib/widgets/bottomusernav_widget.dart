import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color:
                  Colors.black.withOpacity(0.4), // Darker frosted glass effect
              borderRadius: BorderRadius.circular(20),
              // Darker border
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Darker shadow
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GNav(
              gap: 8,
              backgroundColor: Colors.transparent,
              color: Colors.grey[200],
              activeColor: Colors.white,
              tabBackgroundColor: secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              tabs: const [
                GButton(
                  icon: LucideIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LucideIcons.bookOpen,
                  text: 'Library',
                ),
                GButton(
                  icon: LucideIcons.bookCopy,
                  text: 'My Books',
                ),
                GButton(
                  icon: LucideIcons.userCircle2,
                  text: 'Account',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: onTabChange,
            ),
          ),
        ),
      ),
    );
  }
}
