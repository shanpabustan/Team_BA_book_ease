import 'package:book_ease/screens/user/user_components/book_detail_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/provider/book_provider.dart';
import 'package:book_ease/screens/user/library/book_tile.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/provider/user_data.dart';

class SearchBookScreen extends StatefulWidget {
  const SearchBookScreen({super.key});

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final allBooks = bookProvider.books;

    final results = allBooks.where((book) {
      final searchQuery = query.toLowerCase();
      return book.title.toLowerCase().contains(searchQuery) ||
          book.author.toLowerCase().contains(searchQuery) ||
          book.category.toLowerCase().contains(searchQuery) ||
          book.description.toLowerCase().contains(searchQuery) ||
          book.isbn.toLowerCase().contains(searchQuery);
    }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserData>(context).userID;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AdminColor.secondaryBackgroundColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              constraints: const BoxConstraints(),
            ),
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Start typing to search books...'
                            : 'No books found for "${_searchController.text}"',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final book = _searchResults[index];
                    return GestureDetector(
                      onTap: () => showBookDetailsModal(
                        context: context,
                        book: book,
                        userId: userId,
                      ),
                      child: BookItem(book: book),
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
