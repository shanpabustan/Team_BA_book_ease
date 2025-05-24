// // lib/screens/search/search_screen_base.dart
// import 'package:book_ease/utils/search_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:book_ease/screens/admin/admin_theme.dart';

// class SearchScreenBase extends StatefulWidget {
//   final List<Map<String, String>> database;
//   final List<Map<String, String>> history;

//   final String title;

//   const SearchScreenBase({
//     super.key,
//     required this.database,
//     required this.history,
//     required this.title,
//   });

//   @override
//   State<SearchScreenBase> createState() => _SearchScreenBaseState();
// }

// class _SearchScreenBaseState extends State<SearchScreenBase> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Map<String, String>> filteredResults = [];
//   bool _noResults = false;

//   void _onSearch(String query) {
//     setState(() {
//       filteredResults = SearchHelper.filterData(query, widget.database);
//       _noResults = filteredResults.isEmpty;

//       if (filteredResults.isNotEmpty) {
//         SearchHelper.updateSearchHistory(
//           title: query,
//           thumbnail: filteredResults.first['thumbnail']!,
//           history: widget.history,
//         );
//       }
//     });
//   }

//   void _clearHistory() {
//     setState(() {
//       SearchHelper.clearHistory(widget.history);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final showHistory = widget.history.isNotEmpty && filteredResults.isEmpty;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AdminColor.secondaryBackgroundColor,
//         automaticallyImplyLeading: false,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               constraints: const BoxConstraints(),
//             ),
//             Expanded(
//               child: Container(
//                 height: 40,
//                 margin: const EdgeInsets.only(right: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: _onSearch,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     hintText: 'Search for books...',
//                     hintStyle: GoogleFonts.poppins(color: Colors.grey),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 8),
//                     prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: _noResults
//           ? Center(
//               child: Text(
//                 "No matching results found.",
//                 style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
//               ),
//             )
//           : Column(
//               children: [
//                 if (showHistory)
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Recent Searches",
//                             style: GoogleFonts.poppins(
//                                 fontSize: 16, fontWeight: FontWeight.w600)),
//                         TextButton(
//                           onPressed: _clearHistory,
//                           child: Text("Clear All",
//                               style: GoogleFonts.poppins(
//                                   fontSize: 14, color: Colors.red)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     itemCount: filteredResults.isNotEmpty
//                         ? filteredResults.length
//                         : widget.history.length,
//                     itemBuilder: (context, index) {
//                       final item = filteredResults.isNotEmpty
//                           ? filteredResults[index]
//                           : widget.history[index];

//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 6),
//                         child: GestureDetector(
//                           onTap: () {
//                             _searchController.text = item['title']!;
//                             _onSearch(item['title']!);
//                           },
//                           child: Row(
//                             children: [
//                               if (filteredResults.isNotEmpty)
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(6),
//                                   child: Image.asset(
//                                     item['thumbnail']!,
//                                     width: 50,
//                                     height: 70,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )
//                               else
//                                 const Icon(Icons.history,
//                                     color: Colors.grey, size: 30),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   item['title']!,
//                                   style: GoogleFonts.poppins(fontSize: 16),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               if (filteredResults.isEmpty)
//                                 IconButton(
//                                   icon: const Icon(Icons.close,
//                                       color: Colors.grey),
//                                   onPressed: () {
//                                     setState(() {
//                                       widget.history.removeAt(index);
//                                     });
//                                   },
//                                 ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
