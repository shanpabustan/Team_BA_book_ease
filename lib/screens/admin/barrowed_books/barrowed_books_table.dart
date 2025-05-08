import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/barrowed_books/barrowed_books_data.dart';
import 'package:book_ease/screens/admin/barrowed_books/barrowed_return_modal.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/admin/components/reuse_dash_card.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';
import 'package:book_ease/screens/admin/components/paginated_table.dart';

class BorrowedBooksApp extends StatelessWidget {
  const BorrowedBooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const BorrowedBooksTableScreen(),
    );
  }
}

class BorrowedBooksTableScreen extends StatefulWidget {
  const BorrowedBooksTableScreen({super.key});

  @override
  State<BorrowedBooksTableScreen> createState() =>
      _BorrowedBooksTableScreenState();
}

class _BorrowedBooksTableScreenState extends State<BorrowedBooksTableScreen> {
  List<BorrowedBookAdmin> originalData = [];
  late TableController<BorrowedBookAdmin> controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBorrowedBooks();
  }

  Future<void> fetchBorrowedBooks() async {
    try {
      final response =
          await Dio().get('${ApiConfig.baseUrl}/admin/get-borrowed-books');

      if (response.statusCode == 200) {
        final List<BorrowedBookAdmin> borrowedBooks = (response.data as List)
            .where((item) => item != null)
            .map<BorrowedBookAdmin>((item) => BorrowedBookAdmin.fromJson(item))
            .toList();

        setState(() {
          originalData = borrowedBooks;
          controller = TableController<BorrowedBookAdmin>(
            dataList: borrowedBooks,
            onPageChange: () => setState(() {}),
          );
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error loading borrowed books: $e");
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
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildActionButtons(),
                      const SizedBox(height: 20),
                      _buildBorrowedBooksTable(),
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
          onPdfPressed: () {
            // TODO: Export to PDF
          },
          onExcelPressed: () {
            // TODO: Export to Excel
          },
        ),
        const Spacer(),
        SearchTable<BorrowedBookAdmin>(
          originalData: originalData,
          searchableFields: [
            'borrowID',
            'userID',
            'name',
            'bookName',
            'status'
          ],
          getFieldValue: (item) =>
              '${item.borrowID} ${item.userID} ${item.name} ${item.bookName} ${item.status}',
          hintText: 'Search borrowed books...',
          onFiltered: (filteredData) {
            setState(() {
              controller.updateDataList(filteredData);
            });
          },
        ),
      ],
    );
  }

  Widget _buildBorrowedBooksTable() {
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
      _sortableColumn('Borrow ID', 'borrowID'),
      _sortableColumn('User ID', 'userID'),
      _sortableColumn('Name', 'name'),
      _sortableColumn('Book Name', 'bookName'),
      _sortableColumn('Status', 'status'),
      const DataColumn(
        label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
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
      onSort: (i, asc) => controller.sort(
        (BorrowedBookAdmin d) => d.getField(field),
        i,
        asc,
        () => setState(() {}),
      ),
    );
  }

  List<DataRow> _buildTableRows() {
    return List.generate(
      controller.currentPageData.length,
      (index) {
        final borrowedBook =
            controller.currentPageData[index]; // This is a BorrowedBookAdmin
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
          cells: _buildRowCells(borrowedBook, index, isSelected),
        );
      },
    );
  }

  List<DataCell> _buildRowCells(
      BorrowedBookAdmin borrowedBook, int index, bool isSelected) {
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
      DataCell(Text(borrowedBook.borrowID.toString())),
      DataCell(Text(borrowedBook.userID)),
      DataCell(SizedBox(
        width: 250,
        child: Text(borrowedBook.name, overflow: TextOverflow.ellipsis),
      )),
      DataCell(SizedBox(
        width: 250,
        child: Text(borrowedBook.bookName, overflow: TextOverflow.ellipsis),
      )),
      DataCell(buildBarrowedStatusChip(borrowedBook.status)),
      DataCell(
        Row(
          children: [
            Tooltip(
              message: 'Return',
              child: IconButton(
                icon: const Icon(Icons.library_books, size: 20),
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ReturnBookModal(
                      returnData: borrowedBook,
                    ),
                  );

                  if (result != null && result['success'] == true) {
                    if (context.mounted) {
                      showSuccessSnackBar(
                        context,
                        title: 'Success!',
                        message: 'Book returned successfully.',
                      );
                      fetchBorrowedBooks(); // Refresh after return
                    }
                  }
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
