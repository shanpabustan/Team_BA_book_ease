import 'package:flutter/material.dart';
import 'package:book_ease/screens/user/user_components/book_detail_helper.dart';
import 'package:book_ease/screens/user/my_books/add_to_my_books.dart';
import 'package:book_ease/screens/user/library/reservation_modal.dart';

void showBookDetailsModal({
  required BuildContext context,
  required dynamic book,
  required String userId,
}) {
  final screenHeight = MediaQuery.of(context).size.height; // ✅ Add this line

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (context) {
      bool isFavorited = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: screenHeight, // ✅ Now this works
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: "Close",
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    BookDetailContent(
                      book: book,
                      userId: userId,
                      showReserveButton: true,
                      showFavoriteButton: true,
                      isFavorited: isFavorited,
                      onReserve: () {
                        showReservationModal(
                          context,
                          book.title,
                          book.copies,
                          book.bookId,
                          userId,
                        );
                      },
                      onFavoriteToggle: () {
                        setState(() => isFavorited = !isFavorited);
                        if (isFavorited) {
                          addToMyBooks(context, book.title);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
