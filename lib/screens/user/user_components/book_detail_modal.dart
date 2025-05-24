import 'package:flutter/material.dart';
import 'package:book_ease/screens/user/user_components/book_detail_helper.dart';
import 'package:book_ease/screens/user/my_books/add_to_my_books.dart';
import 'package:book_ease/screens/user/library/reservation_modal.dart';
import 'package:book_ease/services/favorite_books_service.dart';

void showBookDetailsModal({
  required BuildContext context,
  required dynamic book,
  required String userId,
}) {
  final screenHeight = MediaQuery.of(context).size.height;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FutureBuilder<bool>(
            future: FavoriteBooksService.isBookFavorited(book.isbn),
            builder: (context, snapshot) {
              bool isFavorited = snapshot.data ?? false;

              return Container(
                height: screenHeight,
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
                          onFavoriteToggle: () async {
                            if (isFavorited) {
                              await FavoriteBooksService.removeFromFavorites(book.isbn);
                            } else {
                              await FavoriteBooksService.addToFavorites(book.toJson());
                            }
                            setState(() => isFavorited = !isFavorited);
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
    },
  );
}
