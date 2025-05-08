import 'package:book_ease/modals/validation_modal.dart';
import 'package:book_ease/screens/admin/reservation/reservation_data.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the google_fonts package
import 'package:dio/dio.dart';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/components/reuse_dash_card.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';
import 'package:book_ease/screens/admin/components/paginated_table.dart';

class ReservationTable extends StatefulWidget {
  const ReservationTable({super.key});

  @override
  State<ReservationTable> createState() => _ReservationTableState();
}

class _ReservationTableState extends State<ReservationTable> {
  List<Map<String, String>> _originalDataList = [];
  late TableController<Map<String, String>> controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      final response =
          await Dio().get('${ApiConfig.baseUrl}/admin/get-reservations');
      final List<dynamic> data = response.data;

      final List<Map<String, String>> parsedList = data.map((json) {
        final reservation = Reservation.fromJson(json);
        return {
          'reservationId': reservation.reservationId.toString(),
          'userName': reservation.fullName,
          'bookTitle': reservation.bookTitle,
          'preferredPickupDate': reservation.preferredPickupDate
              .toIso8601String()
              .split('T')
              .first,
          'status': reservation.status,
        };
      }).toList();

      setState(() {
        _originalDataList = parsedList; // ✅ store the original unfiltered list
        controller = TableController<Map<String, String>>(
          dataList: parsedList,
          onPageChange: () => setState(() {}),
        );
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching reservations: $e');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: ReusableDashboardCard(
        outerPadding: const EdgeInsets.all(0),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
        width: double.infinity,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                  _buildReservationTable(),
                  const SizedBox(height: 10),
                  _buildPagination(),
                ],
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
        SearchTable<Map<String, String>>(
          originalData: _originalDataList,
          searchableFields: [
            'reservationId',
            'userName',
            'bookTitle',
            'preferredPickupDate',
            'status',
          ],
          getFieldValue: (item) => item.values.join(' '),
          hintText: 'Search reservations...',
          onFiltered: (filteredData) {
            setState(() {
              controller.updateDataList(filteredData);
            });
          },
        ),
      ],
    );
  }

  Widget _buildReservationTable() {
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
      _sortableColumn('Reservation ID', 'reservationId'),
      _sortableColumn('Name', 'userName'),
      _sortableColumn('Book Title', 'bookTitle'),
      _sortableColumn('Pickup Date', 'preferredPickupDate'),
      _sortableColumn('Status', 'status'),
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
        final data = controller.currentPageData[index];
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
          cells: _buildRowCells(data, index, isSelected),
        );
      },
    );
  }

  List<DataCell> _buildRowCells(
      Map<String, String> data, int index, bool isSelected) {
    return [
      DataCell(
        Checkbox(
          value: isSelected,
          onChanged: (_) {
            controller.toggleSingleRowSelection(index, () => setState(() {}));
          },
          activeColor: Colors.teal,
        ),
      ),
      DataCell(Text(data['reservationId']!)),
      DataCell(SizedBox(
          width: 200,
          child: Text(data['userName']!, overflow: TextOverflow.ellipsis))),
      DataCell(SizedBox(
          width: 200,
          child: Text(data['bookTitle']!, overflow: TextOverflow.ellipsis))),
      DataCell(Text(data['preferredPickupDate']!)),
      DataCell(buildReservationStatusChip(data['status']!)),
      DataCell(Row(
        children: [
          Tooltip(
            message: 'Mark as Picked Up',
            child: IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => ValidationModal(
                    onCancel: () => Navigator.pop(context),
                    onValidate: () async {
                      try {
                        final reservationId = data['reservationId'];

                        final response = await Dio().put(
                          '${ApiConfig.baseUrl}/admin/approve-reservation/$reservationId',
                          data: {
                            'reservation_id':
                                int.parse(reservationId!), // ensure it's an int
                          },
                        );

                        if (response.statusCode == 200) {
                          showSuccessSnackBar(
                            context,
                            title: 'Success',
                            message: 'Reservation approved!',
                          );
                          fetchReservations(); // Refresh the table data
                        } else {
                          showWarningSnackBar(
                            context,
                            title: 'Warning',
                            message:
                                'Approval failed: ${response.statusMessage}',
                          );
                        }
                      } catch (e) {
                        showErrorSnackBar(
                          context,
                          title: 'Error',
                          message: 'Error: $e',
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      )),
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
