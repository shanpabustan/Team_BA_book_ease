import 'package:book_ease/screens/admin/barrowed_books/barrowed_books_data.dart';
import 'package:book_ease/screens/admin/barrowed_books/barrowed_return_modal.dart';
import 'package:book_ease/screens/admin/components/paginated_table.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/widgets/reuse_dash_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BorrowedBooksTable extends StatelessWidget {
  const BorrowedBooksTable({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const BorrowedBooksScreen(),
    );
  }
}

class BorrowedBooksScreen extends StatefulWidget {
  const BorrowedBooksScreen({super.key});

  @override
  State<BorrowedBooksScreen> createState() => _BorrowedBooksScreenState();
}

class _BorrowedBooksScreenState extends State<BorrowedBooksScreen> {
  late TableController<Map<String, dynamic>> controller;
  late List<Map<String, dynamic>> _originalData;

  @override
  void initState() {
    super.initState();
    _originalData = List.from(borrowedBooksData);
    controller = TableController<Map<String, dynamic>>(
      dataList: List.from(_originalData),
      onPageChange: () => setState(() {}),
    );
  }

  void _onFiltered(List<Map<String, dynamic>> filteredData) {
    controller.updateData(filteredData, () => setState(() {}));
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
            child: Column(
              children: [
                Row(
                  children: [
                    ActionButtonRow(
                      isButtonEnabled: controller.isButtonEnabled,
                      onPdfPressed: () {
                        // TODO: Implement PDF export
                      },
                      onExcelPressed: () {
                        // TODO: Implement Excel export
                      },
                    ),
                    const Spacer(),
                    SearchTable<Map<String, dynamic>>(
                      originalData: _originalData,
                      searchableFields: [
                        'borrowID',
                        'userID',
                        'name',
                        'bookName',
                        'status',
                      ],
                      getFieldValue: (item) => item.toString(),
                      onFiltered: _onFiltered,
                      hintText: 'Search borrowed books...',
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
                                        controller.toggleSelectAll(
                                            value, () => setState(() {})),
                                    activeColor: Colors.teal,
                                  ),
                                ),
                                DataColumn(
                                  label: buildSortableColumnLabel('Borrow ID'),
                                  onSort: (i, asc) => controller.sort(
                                    (d) => d['borrowID'].toString(),
                                    i,
                                    asc,
                                    () => setState(() {}),
                                  ),
                                ),
                                DataColumn(
                                  label: buildSortableColumnLabel('User ID'),
                                  onSort: (i, asc) => controller.sort(
                                    (d) => d['userID'].toString(),
                                    i,
                                    asc,
                                    () => setState(() {}),
                                  ),
                                ),
                                DataColumn(
                                  label: buildSortableColumnLabel('Name'),
                                  onSort: (i, asc) => controller.sort(
                                    (d) => d['name'].toString(),
                                    i,
                                    asc,
                                    () => setState(() {}),
                                  ),
                                ),
                                DataColumn(
                                  label: buildSortableColumnLabel('Book Name'),
                                  onSort: (i, asc) => controller.sort(
                                    (d) => d['bookName'].toString(),
                                    i,
                                    asc,
                                    () => setState(() {}),
                                  ),
                                ),
                                DataColumn(
                                  label: buildSortableColumnLabel('Status'),
                                  onSort: (i, asc) => controller.sort(
                                    (d) => d['status'].toString(),
                                    i,
                                    asc,
                                    () => setState(() {}),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    'Action',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                  controller.currentPageData.length, (index) {
                                final borrowedBook =
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
                                              index, () => setState(() {}));
                                        },
                                        activeColor: Colors.teal,
                                      ),
                                    ),
                                    DataCell(Text(
                                        borrowedBook['borrowID']?.toString() ??
                                            '')),
                                    DataCell(Text(
                                        borrowedBook['userID']?.toString() ??
                                            '')),
                                    DataCell(SizedBox(
                                      width: 190,
                                      child: Text(
                                        borrowedBook['name']?.toString() ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    )),
                                    DataCell(SizedBox(
                                      width: 250,
                                      child: Text(
                                        borrowedBook['bookName']?.toString() ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    )),
                                    DataCell(buildBarrowedStatusChip(
                                        borrowedBook['status']?.toString() ??
                                            '')),
                                    DataCell(
                                      Row(
                                        children: [
                                          Tooltip(
                                            message: 'Return',
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.library_books,
                                                  size: 20),
                                              onPressed: () async {
                                                final selectedBook =
                                                    borrowedBooksData[
                                                        actualIndex];

                                                final result = await showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) =>
                                                      ReturnBookModal(
                                                          returnData:
                                                              selectedBook),
                                                );

                                                if (result != null &&
                                                    result['success'] == true) {
                                                  if (mounted) {
                                                    showSuccessSnackBar(
                                                      context,
                                                      title: 'Success!',
                                                      message:
                                                          'Book returned successfully.',
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                const SizedBox(height: 10),
                PaginationWidget(
                  currentPage: controller.currentPage,
                  rowsPerPage: controller.rowsPerPage,
                  totalRows: controller.dataList.length,
                  onFirstPage: controller.paginationController.firstPage,
                  onPreviousPage: controller.paginationController.previousPage,
                  onNextPage: controller.paginationController.nextPage,
                  onLastPage: controller.paginationController.lastPage,
                  onRowsPerPageChanged: (value) {
                    controller.updateRowsPerPage(value, () => setState(() {}));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
