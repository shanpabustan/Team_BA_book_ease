import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/usermanagement/view_user.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/widgets/reuse_dash_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/screens/admin/components/action_buttons.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/components/table_controller.dart';
import 'package:book_ease/screens/admin/components/paginated_table.dart';

class UserManagementTable extends StatelessWidget {
  const UserManagementTable({super.key});

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
  late TableController<Map<String, String>> controller;
  bool isLoading = false;
  List<Map<String, String>> users = [];

  @override
  void initState() {
    super.initState();
    controller = TableController<Map<String, String>>(
      dataList: users,
      onPageChange: () => setState(() {}),
    );
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final dio = Dio();
    final url = '${ApiConfig.baseUrl}/admin/get-users';

    setState(() {
      isLoading = true;
    });

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

        setState(() {
          users = fetchedUsers
              .map((user) =>
                  user.map((key, value) => MapEntry(key, value.toString())))
              .toList();
          controller.dataList = users;
          controller.selectedRows =
              List.generate(users.length, (_) => false); // ✅ FIXED HERE
          isLoading = false;
        });
      } else {
        showErrorSnackBar(
          context,
          title: 'Failed!',
          message: 'Failed to load users.',
        );
        setState(() => isLoading = false);
      }
    } catch (e) {
      showErrorSnackBar(
        context,
        title: 'Error!',
        message: 'Error fetching data: $e',
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make the background transparent
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ReusableDashboardCard(
            outerPadding: const EdgeInsets.all(0), // ✅ No bottom padding
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    ActionButtonRow(
                      isButtonEnabled: controller.isButtonEnabled,
                      onPdfPressed: () {},
                      onExcelPressed: () {},
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
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : DataTable(
                                    sortColumnIndex: controller.sortColumnIndex,
                                    sortAscending: controller.ascending,
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                      (_) => const Color(0xFFB8D9D6),
                                    ),
                                    columns: [
                                      DataColumn(
                                          label: Checkbox(
                                        value: controller.isAllSelected,
                                        onChanged: (value) => controller
                                            .toggleSelectAll(value, () {
                                          setState(() {});
                                        }),
                                        activeColor: Colors.teal,
                                      )),
                                      DataColumn(
                                        label:
                                            buildSortableColumnLabel('User ID'),
                                        onSort: (i, asc) => controller.sort(
                                            (d) => d['userId']!,
                                            i,
                                            asc,
                                            () => setState(() {})),
                                      ),
                                      DataColumn(
                                        label: buildSortableColumnLabel('Name'),
                                        onSort: (i, asc) => controller.sort(
                                            (d) => d['name']!,
                                            i,
                                            asc,
                                            () => setState(() {})),
                                      ),
                                      DataColumn(
                                        label:
                                            buildSortableColumnLabel('Email'),
                                        onSort: (i, asc) => controller.sort(
                                            (d) => d['email']!,
                                            i,
                                            asc,
                                            () => setState(() {})),
                                      ),
                                      DataColumn(
                                        label:
                                            buildSortableColumnLabel('Course'),
                                        onSort: (i, asc) => controller.sort(
                                            (d) => d['course']!,
                                            i,
                                            asc,
                                            () => setState(() {})),
                                      ),
                                      DataColumn(
                                        label:
                                            buildSortableColumnLabel('Status'),
                                        onSort: (i, asc) => controller.sort(
                                            (d) => d['status']!,
                                            i,
                                            asc,
                                            () => setState(() {})),
                                      ),
                                      const DataColumn(
                                        label: Text('Action',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                    rows: List.generate(
                                        controller.currentPageData.length,
                                        (index) {
                                      final user =
                                          controller.currentPageData[index];
                                      final actualIndex =
                                          controller.currentPage *
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
                                        }),
                                        cells: [
                                          DataCell(
                                            Checkbox(
                                              value: isSelected,
                                              onChanged: (val) {
                                                controller
                                                    .toggleSingleRowSelection(
                                                        index,
                                                        () => setState(() {}));
                                              },
                                              activeColor: Colors.teal,
                                            ),
                                          ),
                                          DataCell(Text(user['userId']!)),
                                          DataCell(Text(user['name']!)),
                                          DataCell(Text(user['email']!)),
                                          DataCell(Text(user['course']!)),
                                          DataCell(buildUserStatusChip(
                                              user['status']!)),
                                          DataCell(Row(
                                            children: [
                                              Tooltip(
                                                message: 'View User',
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.remove_red_eye,
                                                      size: 20),
                                                  onPressed: () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        ViewUserModal(
                                                            user: user),
                                                  ),
                                                ),
                                              ),
                                              Tooltip(
                                                message: 'Unblock User',
                                                child: IconButton(
                                                  icon: const Icon(
                                                      Icons.lock_open,
                                                      size: 20),
                                                  onPressed: () => showUnblockModal(
                                                      context), // Corrected here
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
