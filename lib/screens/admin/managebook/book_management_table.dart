import 'package:book_ease/base_url.dart';
import 'package:book_ease/widgets/svg_loading_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/managebook/add_book_form.dart';
import 'package:book_ease/screens/admin/managebook/edit_book.dart';
import 'package:book_ease/screens/admin/managebook/view_book.dart';
import 'package:book_ease/screens/admin/components/reuse_dash_card.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';
import 'package:book_ease/screens/admin/components/paginated_table.dart';
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:book_ease/services/export_service.dart';

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
  List<Map<String, String>> _originalDataList = [];
  late TableController<Map<String, String>> controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await Dio().get('${ApiConfig.baseUrl}/get-all');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        final List<Map<String, String>> parsed =
            data.map<Map<String, String>>((json) {
          return {
            'bookId': json['book_id'].toString(),
            'title': json['title'] ?? '',
            'author': json['author'] ?? '',
            'year': json['year_published'].toString(),
            'version': json['version'].toString(),
            'isbn': json['isbn'] ?? '',
            'copies': json['available_copies'].toString(),
            'totalCopies': json['total_copies'].toString(),
            'section': json['library_section'] ?? '',
            'shelfLocation': json['shelf_location'] ?? '',
            'category': json['category'] ?? '',
            'condition': json['book_condition'] ?? '',
            'description': json['description'] ?? '',
            'image': json['picture'] ?? '',
          };
        }).toList();

        setState(() {
          _originalDataList = parsed;
          controller = TableController<Map<String, String>>(
            dataList: parsed,
            onPageChange: () => setState(() {}),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching books: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ReusableDashboardCard(
            outerPadding: const EdgeInsets.all(0),
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            width: double.infinity,
            child: _isLoading
                ? const Center(child: SvgLoadingScreen())
                : Column(
                    children: [
                      _buildActionButtons(),
                      const SizedBox(height: 20),
                      _buildBookTable(),
                      const SizedBox(height: 10),
                      _buildPagination(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ActionButtonRow(
          isButtonEnabled: controller.isButtonEnabled,
          onPdfPressed: () async {
            final selectedBooks = _getSelectedBooks();
            if (selectedBooks.isEmpty) return;

            await ExportService.exportToPdf(
              title: 'Books Report',
              headers: [
                'Book ID',
                'Title',
                'Author',
                'Year',
                'Category',
                'Condition',
                'Copies'
              ],
              data: ExportService.formatBookData(selectedBooks),
              fileName: 'books_report',
            );
          },
          onExcelPressed: () async {
            final selectedBooks = _getSelectedBooks();
            if (selectedBooks.isEmpty) return;

            await ExportService.exportToExcel(
              title: 'Books',
              headers: [
                'Book ID',
                'Title',
                'Author',
                'Year',
                'Category',
                'Condition',
                'Copies'
              ],
              data: ExportService.formatBookData(selectedBooks),
              fileName: 'books_report',
            );
          },
        ),
        const Spacer(),
        SearchTable<Map<String, String>>(
          originalData: _originalDataList,
          searchableFields: [
            'bookId',
            'title',
            'author',
            'year',
            'category',
            'condition',
          ],
          getFieldValue: (item) => item.values.join(' '),
          hintText: 'Search books...',
          onFiltered: (filteredData) {
            setState(() {
              controller.updateDataList(filteredData);
            });
          },
        ),
        const SizedBox(width: 20),
        CustomButton(
          text: "Add New Book",
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddBookForm(),
            ).then((_) => fetchBooks());
          },
        ),
      ],
    );
  }

  List<Map<String, String>> _getSelectedBooks() {
    List<Map<String, String>> selectedBooks = [];
    for (int i = 0; i < controller.selectedRows.length; i++) {
      if (controller.selectedRows[i]) {
        selectedBooks.add(controller.dataList[i]);
      }
    }
    return selectedBooks;
  }

  Widget _buildBookTable() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  sortColumnIndex: controller.sortColumnIndex,
                  sortAscending: controller.ascending,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (_) => const Color(0xFFB8D9D6)),
                  columns: _buildTableColumns(),
                  rows: _buildTableRows(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      DataColumn(
        label: Checkbox(
          value: controller.isAllSelected,
          onChanged: (value) =>
              controller.toggleSelectAll(value, () => setState(() {})),
          activeColor: Colors.teal,
        ),
      ),
      _sortableColumn('Book ID', 'bookId'),
      _sortableColumn('Title', 'title'),
      _sortableColumn('Author', 'author'),
      _sortableColumn('Year', 'year'),
      _sortableColumn('Category', 'category'),
      _sortableColumn('Condition', 'condition'),
      const DataColumn(
          label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
    ];
  }

  DataColumn _sortableColumn(String label, String field) {
    return DataColumn(
      label: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Icon(Icons.unfold_more, size: 16),
        ],
      ),
      onSort: (i, asc) =>
          controller.sort((d) => d[field]!, i, asc, () => setState(() {})),
    );
  }

  List<DataRow> _buildTableRows() {
    return List.generate(
      controller.currentPageData.length,
      (index) {
        final book = controller.currentPageData[index];
        final actualIndex =
            controller.currentPage * controller.rowsPerPage + index;
        final isSelected = controller.selectedRows[actualIndex];

        return DataRow(
          color: MaterialStateColor.resolveWith(
            (states) => isSelected
                ? Colors.teal.shade50
                : index.isEven
                    ? Colors.transparent
                    : Colors.grey.shade100,
          ),
          cells: _buildRowCells(book, index, isSelected),
        );
      },
    );
  }

  List<DataCell> _buildRowCells(
      Map<String, String> book, int index, bool isSelected) {
    return [
      DataCell(
        Checkbox(
          value: isSelected,
          onChanged: (val) {
            controller.toggleSingleRowSelection(index, () => setState(() {}));
          },
          activeColor: Colors.teal,
        ),
      ),
      DataCell(Text(book['bookId']!)),
      DataCell(SizedBox(
          width: 150,
          child: Text(book['author']!, overflow: TextOverflow.ellipsis))),
      DataCell(SizedBox(
          width: 150,
          child: Text(book['title']!, overflow: TextOverflow.ellipsis))),
      DataCell(Text(book['year']!)),
      DataCell(Text(book['category']!)),
      DataCell(buildBooksStatusChip(book['condition']!)),
      DataCell(
        Row(
          children: [
            Tooltip(
              message: 'View Book',
              child: IconButton(
                icon: const Icon(Icons.remove_red_eye, size: 20),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ViewBookModal(book: book),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Edit Book',
              child: IconButton(
                icon: const Icon(Icons.edit_outlined,
                    size: 20, color: Colors.black),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditBookForm(book: book),
                  ).then((_) => fetchBooks());
                },
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildPagination() {
    return PaginationWidget(
      currentPage: controller.currentPage,
      rowsPerPage: controller.rowsPerPage,
      totalRows: controller.dataList.length,
      onFirstPage: controller.paginationController.firstPage,
      onPreviousPage: controller.paginationController.previousPage,
      onNextPage: controller.paginationController.nextPage,
      onLastPage: controller.paginationController.lastPage,
      onRowsPerPageChanged: (value) {
        controller.updateRowsPerPage(value, () {
          setState(() {});
        });
      },
    );
  }
}
