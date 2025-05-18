import 'package:book_ease/screens/user/app_text_styles.dart';
import 'package:book_ease/screens/user/library/favourite_books_screen.dart';
import 'package:book_ease/utils/navigator_helper.dart';
import 'package:book_ease/utils/search_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/main.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationPressed;
  final int unreadCount;

  const AppBarWidget({
    super.key,
    required this.onNotificationPressed,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: secondaryColor,
      title: Row(
        children: [
          Text(
            "BookEase",
            style: AppTextStyles.appBarTitle.copyWith(
              color: Colors.white, // Add color override if needed
            ),
          ),
        ],
      ),
      actions: [
        // Search icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 20),
              onPressed: () {
                fadePush(context, const SearchBookScreen());
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),

        // Notification icon with badge
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications,
                      color: Colors.white, size: 20),
                  onPressed: onNotificationPressed,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 15,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Favorite icon (newly added)
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white, size: 20),
              onPressed: () {
                fadePush(context, const FavouriteBooksScreen());
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
