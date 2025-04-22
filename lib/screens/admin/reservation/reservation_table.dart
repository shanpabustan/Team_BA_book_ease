import 'package:book_ease/base_url.dart';
import 'package:book_ease/modals/validation_modal.dart';
import 'package:book_ease/screens/admin/components/paginated_table.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';
import 'package:book_ease/screens/admin/reservation/reservation_data.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReservationTable extends StatelessWidget {
  const ReservationTable({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const ReservationScreen(),
    );
  }
}

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late TableController<Map<String, String>> controller;

 @override
    void initState() {
      super.initState();
      fetchReservations();
    }

  Future<void> fetchReservations() async {
    try {
      final response = await Dio().get('${ApiConfig.baseUrl}/admin/get-reservations');
      final List<dynamic> data = response.data;

      final List<Map<String, String>> parsedList = data.map((json) {
        final reservation = Reservation.fromJson(json);
        return {
          'reservationId': reservation.reservationId.toString(),
          'userName': reservation.fullName,
          'bookTitle': reservation.bookTitle,
          'preferredPickupDate': reservation.preferredPickupDate.toIso8601String().split('T').first,
          'status': reservation.status,
        };
      }).toList();

      setState(() {
        controller = TableController<Map<String, String>>(
          dataList: parsedList,
          onPageChange: () => setState(() {}),
        );
      });
    } catch (e) {
      print('Error fetching reservations: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
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
                    // TODO: PDF export logic
                  },
                  onExcelPressed: () {
                    // TODO: Excel export logic
                  },
                ),
                const Spacer(),
                const SizedBox(
                  width: 300, // Adjust width as needed
                  child: SearchAdmin(hintText: 'Search reservations...'),
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
                            (_) => const Color(
                                0xFFB8D9D6), // A darker shade of the original color
                          ),
                          columns: [
                            DataColumn(
                              label: Checkbox(
                                value: controller.isAllSelected,
                                onChanged: (value) =>
                                    controller.toggleSelectAll(
                                        value, () => setState(() {})),
                                activeColor:
                                    Colors.teal, // Change fill color to teal
                              ),
                            ),
                            DataColumn(
                              label: buildSortableColumnLabel('Reservation ID'),
                              onSort: (i, asc) => controller.sort(
                                  (d) => d['reservationId']!,
                                  i,
                                  asc,
                                  () => setState(() {})),
                            ),
                            DataColumn(
                              label: buildSortableColumnLabel('User Name'),
                              onSort: (i, asc) => controller.sort(
                                  (d) => d['userName']!,
                                  i,
                                  asc,
                                  () => setState(() {})),
                            ),
                            DataColumn(
                              label: buildSortableColumnLabel('Book Title'),
                              onSort: (i, asc) => controller.sort(
                                  (d) => d['bookTitle']!,
                                  i,
                                  asc,
                                  () => setState(() {})),
                            ),
                            DataColumn(
                              label:
                                  buildSortableColumnLabel('Pickup Date'),
                              onSort: (i, asc) => controller.sort(
                                  (d) => d['preferredPickupDate']!,
                                  i,
                                  asc,
                                  () => setState(() {})),
                            ),
                            DataColumn(
                              label: buildSortableColumnLabel('Status'),
                              onSort: (i, asc) => controller.sort(
                                  (d) => d['status']!,
                                  i,
                                  asc,
                                  () => setState(() {})),
                            ),
                            const DataColumn(
                              label: Text('Action',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                          rows: List.generate(controller.currentPageData.length,
                              (index) {
                            final reservation =
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
                                    return Colors.teal
                                        .shade50; // Highlight row when selected
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
                                DataCell(Text(reservation['reservationId']!)),
                                DataCell(SizedBox(
                                  width: 150,
                                  child: Text(
                                    reservation['userName']!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                DataCell(Text(reservation['bookTitle']!)),
                                DataCell(Text(reservation['preferredPickupDate']!)),
                                DataCell(buildReservationStatusChip(
                                    reservation['status']!)),
                                DataCell(Row(
                                  children: [
                                                              Tooltip(
                              message: 'Picked up',
                              child: IconButton(
                                icon: const Icon(Icons.done_all_rounded, size: 20),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ValidationModal(
                                      onCancel: () => Navigator.pop(context),
                                      onValidate: () async {
                                        try {
                                          final reservationId = reservation['reservationId'];

                                          final response = await Dio().put(
                                            '${ApiConfig.baseUrl}/admin/approve-reservation/$reservationId',
                                            data: {
                                              'reservation_id': int.parse(reservationId!), // ensure it's an int
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
                                              message: 'Approval failed: ${response.statusMessage}',
                                              
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
              onPreviousPage: controller.paginationController.previousPage,
              onNextPage: controller.paginationController.nextPage,
              onLastPage: controller.paginationController.lastPage,
              onRowsPerPageChanged: (value) {
                controller.updateRowsPerPage(value,
                    () => setState(() {})); // Properly updating rows per page
              },
            )
          ],
        ),
      ),
    );
  }
}

