import 'package:book_ease/screens/admin/managebook/add_book_form.dart';
import 'package:book_ease/screens/admin/managebook/book_data.dart';
import 'package:book_ease/screens/admin/managebook/edit_book.dart';
import 'package:book_ease/screens/admin/managebook/view_book.dart';
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/components/paginated_table.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';

class BookManagementApp extends StatelessWidget {
  const BookManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const BookManagementScreen(),
    );
  }
}

class BookManagementScreen extends StatefulWidget {
  const BookManagementScreen({super.key});

  @override
  State<BookManagementScreen> createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  late Future<List<Map<String, String>>> futureBooks;
  List<Map<String, String>> books = [];
  List<bool> selectedRows = [];

  late TableController<Map<String, String>> controller;

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBookList();
    futureBooks.then((data) {
      setState(() {
        books = data;
        selectedRows = List.filled(books.length, false);
        controller = TableController<Map<String, String>>(
          dataList: List.from(books),
          onPageChange: () => setState(() {}),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: futureBooks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          books = snapshot.data!;
          selectedRows = List.filled(books.length, false);

          controller = TableController<Map<String, String>>(
            dataList: List.from(books),
            onPageChange: () => setState(() {}),
          );

          return Scaffold(
            backgroundColor: const Color(0xFFF3F6F9),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      ActionButtonRow(
                        isButtonEnabled: controller.isButtonEnabled,
                        onPdfPressed: () {
                          // TODO: Export PDF logic
                        },
                        onExcelPressed: () {
                          // TODO: Export Excel logic
                        },
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 300,
                        child: SearchAdmin(hintText: 'Search books...'),
                      ),
                      const SizedBox(width: 20),
                      CustomButton(
                        text: "Add New Book",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AddBookForm(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: constraints.maxWidth),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                sortColumnIndex: controller.sortColumnIndex,
                                sortAscending: controller.ascending,
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (_) => const Color(0xFFB8D9D6),
                                ),
                                columns: [
                                  DataColumn(
                                    label: Checkbox(
                                      value: controller.isAllSelected,
                                      onChanged: (value) =>
                                          controller.toggleSelectAll(value, () {
                                        setState(() {});
                                      }),
                                      activeColor: Colors.teal,
                                    ),
                                  ),
                                  DataColumn(
                                    label: buildSortableColumnLabel('Book ID'),
                                    onSort: (i, asc) => controller.sort(
                                      (d) => d['bookId']!,
                                      i,
                                      asc,
                                      () => setState(() {}),
                                    ),
                                  ),
                                  DataColumn(
                                    label: buildSortableColumnLabel('Title'),
                                    onSort: (i, asc) => controller.sort(
                                      (d) => d['title']!,
                                      i,
                                      asc,
                                      () => setState(() {}),
                                    ),
                                  ),
                                  DataColumn(
                                    label: buildSortableColumnLabel('Author'),
                                    onSort: (i, asc) => controller.sort(
                                      (d) => d['author']!,
                                      i,
                                      asc,
                                      () => setState(() {}),
                                    ),
                                  ),
                                  DataColumn(
                                    label: buildSortableColumnLabel('Year'),
                                    onSort: (i, asc) => controller.sort(
                                      (d) => d['year']!,
                                      i,
                                      asc,
                                      () => setState(() {}),
                                    ),
                                  ),
                                  DataColumn(
                                    label: buildSortableColumnLabel('Category'),
                                    onSort: (i, asc) => controller.sort(
                                      (d) => d['category']!,
                                      i,
                                      asc,
                                      () => setState(() {}),
                                    ),
                                  ),
                                  DataColumn(
                                    label:
                                        buildSortableColumnLabel('Condition'),
                                    onSort: (i, asc) => controller.sort(
                                      (d) => d['condition']!,
                                      i,
                                      asc,
                                      () => setState(() {}),
                                    ),
                                  ),
                                  const DataColumn(
                                    label: Text('Action',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                                rows: List.generate(
                                    controller.currentPageData.length, (index) {
                                  final book =
                                      controller.currentPageData[index];
                                  final actualIndex = controller.currentPage *
                                          controller.rowsPerPage +
                                      index;
                                  final isSelected =
                                      controller.selectedRows[actualIndex];

                                  return DataRow(
                                    color: MaterialStateColor.resolveWith(
                                      (states) {
                                        if (isSelected) {
                                          return Colors.teal.shade50;
                                        }
                                        return index.isEven
                                            ? Colors.transparent
                                            : Colors.grey.shade100;
                                      },
                                    ),
                                    cells: [
                                      DataCell(
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (val) {
                                            controller.toggleSingleRowSelection(
                                                index, () {
                                              setState(() {});
                                            });
                                          },
                                          activeColor: Colors.teal,
                                        ),
                                      ),
                                      DataCell(Text(book['bookId']!)),
                                      DataCell(SizedBox(
                                        width: 150,
                                        child: Text(
                                          book['title']!,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                      DataCell(Text(book['author']!)),
                                      DataCell(Text(book['year']!)),
                                      DataCell(Text(book['category']!)),
                                      DataCell(Text(book['condition']!)),
                                      DataCell(Row(
                                        children: [
                                          Tooltip(
                                            message: 'View Book',
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  size: 20,
                                                  color: Colors.black),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      ViewBookModal(book: book),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Tooltip(
                                            message: 'Edit Book',
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 20,
                                                  color: Colors.black),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      EditBookForm(book: book),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  PaginationWidget(
                    currentPage: controller.currentPage,
                    rowsPerPage: controller.rowsPerPage,
                    totalRows: controller.dataList.length,
                    onFirstPage: controller.paginationController.firstPage,
                    onPreviousPage:
                        controller.paginationController.previousPage,
                    onNextPage: controller.paginationController.nextPage,
                    onLastPage: controller.paginationController.lastPage,
                    onRowsPerPageChanged: (value) {
                      controller.updateRowsPerPage(value, () {
                        setState(() {});
                      });
                    },
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
