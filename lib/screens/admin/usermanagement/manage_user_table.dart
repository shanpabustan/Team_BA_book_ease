import 'package:book_ease/modals/unblock_data_modal.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/usermanagement/view_user.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/widgets/svg_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/components/reuse_dash_card.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';
import 'package:book_ease/screens/admin/components/paginated_table.dart';
import 'package:book_ease/services/export_service.dart';

class UserManagementApp extends StatelessWidget {
  const UserManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const UserManagementScreen(),
    );
  }
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<Map<String, String>> _originalDataList = [];
  late TableController<Map<String, String>> controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final dio = Dio();
    final url = '${ApiConfig.baseUrl}/admin/get-users';

    setState(() => isLoading = true);
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        List<Map<String, dynamic>> fetchedUsers = data.map((user) {
          return {
            'userId': user['user_id'].toString(),
            'name': user['name'],
            'email': user['email'],
            'course': user['program'] ?? 'N/A',
            'status': user['is_active'] ? 'Active' : 'Blocked',
            'phoneNumber': user['contact_number'] ?? 'N/A',
            'yearLevel': user['year_level']?.toString() ?? 'N/A',
          };
        }).toList();

        final parsed = fetchedUsers
            .map((user) =>
                user.map((key, value) => MapEntry(key, value.toString())))
            .toList();

        setState(() {
          _originalDataList = parsed;
          controller = TableController<Map<String, String>>(
            dataList: parsed,
            onPageChange: () => setState(() {}),
          );
          isLoading = false;
        });
      } else {
        showErrorSnackBar(context,
            title: 'Failed', message: 'Failed to load users.');
        setState(() => isLoading = false);
      }
    } catch (e) {
      showErrorSnackBar(context,
          title: 'Error', message: 'Error fetching data: $e');
      setState(() => isLoading = false);
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
            child: isLoading
                ? const Center(child: SvgLoadingScreen())
                : Column(
                    children: [
                      _buildHeaderRow(),
                      const SizedBox(height: 20),
                      _buildUserTable(),
                      const SizedBox(height: 10),
                      _buildPagination(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        ActionButtonRow(
          isButtonEnabled: controller.isButtonEnabled,
          onPdfPressed: () async {
            final selectedUsers = _getSelectedUsers();
            if (selectedUsers.isEmpty) return;

            await ExportService.exportToPdf(
              title: 'Users Report',
              headers: [
                'User ID',
                'Name',
                'Email',
                'Course',
                'Year Level',
                'Status'
              ],
              data: ExportService.formatUserData(selectedUsers),
              fileName: 'users_report',
            );
          },
          onExcelPressed: () async {
            final selectedUsers = _getSelectedUsers();
            if (selectedUsers.isEmpty) return;

            await ExportService.exportToExcel(
              title: 'Users',
              headers: [
                'User ID',
                'Name',
                'Email',
                'Course',
                'Year Level',
                'Status'
              ],
              data: ExportService.formatUserData(selectedUsers),
              fileName: 'users_report',
            );
          },
        ),
        const Spacer(),
        SearchTable<Map<String, String>>(
          originalData: _originalDataList,
          searchableFields: ['userId', 'name', 'email', 'course', 'status'],
          getFieldValue: (user) => user.values.join(' '),
          hintText: 'Search users...',
          onFiltered: (filteredData) {
            setState(() {
              controller.updateDataList(filteredData);
            });
          },
        ),
      ],
    );
  }

  Widget _buildUserTable() {
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
      _sortableColumn('User ID', 'userId'),
      _sortableColumn('Name', 'name'),
      _sortableColumn('Email', 'email'),
      _sortableColumn('Course', 'course'),
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
        final user = controller.currentPageData[index];
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
          cells: _buildRowCells(user, index, isSelected),
        );
      },
    );
  }

  List<DataCell> _buildRowCells(
      Map<String, String> user, int index, bool isSelected) {
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
      DataCell(Text(user['userId']!)),
      DataCell(SizedBox(
          width: 200,
          child: Text(user['name']!, overflow: TextOverflow.ellipsis))),
      DataCell(SizedBox(
          width: 200,
          child: Text(user['email']!, overflow: TextOverflow.ellipsis))),
      DataCell(Text(user['course']!)),
      DataCell(buildUserStatusChip(user['status']!)),
      DataCell(Row(
        children: [
          Tooltip(
            message: 'View User',
            child: IconButton(
              icon: const Icon(Icons.remove_red_eye, size: 20),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => ViewUserModal(user: user),
              ),
            ),
          ),
          Tooltip(
            message: 'Unblock User',
            child: IconButton(
              icon: const Icon(Icons.lock_open, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => UnblockDataModal(
                    onCancel: () =>
                        Navigator.pop(context), // Close the modal on cancel
                    onUnblock: () async {
                      final userId =
                          user['userId']; // Get userId from the user data
                      try {
                        final response = await Dio().put(
                          '${ApiConfig.baseUrl}/admin/unblock-student/$userId', // Corrected URL
                        );

                        if (response.statusCode == 200) {
                          showSuccessSnackBar(
                            context,
                            title: 'Success',
                            message: 'User unblocked successfully!',
                          );
                          _fetchUsers(); // Refresh the UI or user data
                        } else {
                          showErrorSnackBar(
                            context,
                            title: 'Error',
                            message:
                                'Failed to unblock user: ${response.statusMessage}',
                          );
                        }
                      } catch (e) {
                        showErrorSnackBar(
                          context,
                          title: 'Error',
                          message: 'An error occurred: $e',
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

  List<Map<String, String>> _getSelectedUsers() {
    List<Map<String, String>> selectedUsers = [];
    for (int i = 0; i < controller.selectedRows.length; i++) {
      if (controller.selectedRows[i]) {
        selectedUsers.add(controller.dataList[i]);
      }
    }
    return selectedUsers;
  }
}
