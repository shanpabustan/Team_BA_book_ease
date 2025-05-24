import 'package:book_ease/screens/user/user_components/book_detail_modal.dart';
import 'package:book_ease/widgets/svg_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/screens/user/library/book_tile.dart';
import 'package:book_ease/provider/book_data.dart';

class BookGrid extends StatelessWidget {
  final String userId;
  final String selectedCategory;

  const BookGrid({
    super.key,
    required this.userId,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bookProvider = Provider.of<BookProvider>(context);

    // 🧠 Show centered loading screen in fixed height box
    if (bookProvider.isLoading) {
      return const SizedBox(
        height: 630,
        child: Center(child: SvgLoadingScreen()),
      );
    }

    // 🧠 Apply category filter
    final books = selectedCategory == 'All'
        ? bookProvider.books
        : bookProvider.books
            .where((b) => b.category == selectedCategory)
            .toList();

    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 5;
    } else if (screenWidth >= 900) {
      crossAxisCount = 4;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: books.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showBookDetailsModal(
                context: context,
                book: book,
                userId: userId,
              );
            },
            child: BookItem(book: book),
          ),
        );
      },
    );
  }
}
