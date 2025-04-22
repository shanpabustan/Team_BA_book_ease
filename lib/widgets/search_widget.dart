import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/data/search_data.dart';
import 'package:book_ease/services/voice_to_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final VoiceToTextService _voiceService = VoiceToTextService();
  List<Map<String, String>> filteredBooks = [];
  bool _noResults = false;

  /// Filters books based on the search query
  void _onSearch(String query) {
    setState(() {
      filteredBooks = bookDatabase
          .where((book) =>
              book['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      _noResults = filteredBooks.isEmpty;

      if (filteredBooks.isNotEmpty) {
        _updateSearchHistory(query, filteredBooks.first['thumbnail']!);
      }
    });
  }

  /// Updates the search history
  void _updateSearchHistory(String title, String thumbnail) {
    final existingIndex =
        searchHistory.indexWhere((book) => book['title'] == title);

    if (existingIndex == -1) {
      setState(() {
        searchHistory.insert(0, {'title': title, 'thumbnail': thumbnail});
        if (searchHistory.length > 10) searchHistory.removeLast();
      });
    }
  }

  /// Clears search history
  void _clearSearchHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  /// Starts voice search and auto-searches after speech
  Future<void> _startVoiceSearch() async {
    bool initialized = await _voiceService.initialize();

    if (!initialized) {
      print("Speech recognition could not be initialized.");
      return;
    }

    if (!_voiceService.isListening) {
      String? voiceResult = await _voiceService.startListening();
      if (voiceResult != null && voiceResult.isNotEmpty) {
        setState(() {
          _searchController.text = voiceResult;
          _onSearch(voiceResult);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearch,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search for books...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            onPressed: _startVoiceSearch, // ✅ Trigger voice search
            tooltip: "Voice Search",
          ),
        ],
      ),
      body: _noResults
          ? Center(
              child: Text(
                "No matching results found.",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                if (searchHistory.isNotEmpty && filteredBooks.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Searches",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: _clearSearchHistory,
                          child: Text(
                            "Clear All",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: filteredBooks.isNotEmpty
                        ? filteredBooks.length
                        : searchHistory.length,
                    itemBuilder: (context, index) {
                      final item = filteredBooks.isNotEmpty
                          ? filteredBooks[index]
                          : searchHistory[index];

                      return ListTile(
                        leading: filteredBooks.isNotEmpty
                            ? Image.asset(
                                item['thumbnail']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.history, color: Colors.grey),
                        title: Text(
                          item['title']!,
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        trailing: filteredBooks.isEmpty
                            ? IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    searchHistory.removeAt(index);
                                  });
                                },
                              )
                            : null,
                        onTap: () {
                          _searchController.text = item['title']!;
                          _onSearch(item['title']!);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
