import 'package:book_ease/modals/unblock_data_modal.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:flutter/material.dart';

class TableController<T> {
  late PaginationController paginationController;
  int currentPage = 0;
  int rowsPerPage;
  bool ascending = true;
  int? sortColumnIndex;
  bool isAllSelected = false;
  bool isButtonEnabled = false;

  List<T> dataList;
  List<bool> selectedRows = [];

  List<int> rowsPerPageOptions = [];

  TableController({
    required this.dataList,
    this.rowsPerPage = 10,
    required VoidCallback onPageChange,
  }) {
    selectedRows = List.generate(dataList.length, (_) => false);
    paginationController = PaginationController(
      rowsPerPage: rowsPerPage,
      totalRows: dataList.length,
      currentPage: currentPage,
      onPageChange: () {
        currentPage = paginationController.currentPage;
        _checkSelectAllState();
        _checkButtonState();
        onPageChange();
      },
    );
    _generateRowsPerPageOptions(); // Generate dynamic rows per page options
  }

  // Dynamically generate rows per page options based on the total data length
  void _generateRowsPerPageOptions() {
    rowsPerPageOptions = [10];
    int increment = 10;
    int totalRows = dataList.length;
    while (rowsPerPageOptions.last < totalRows) {
      rowsPerPageOptions.add(rowsPerPageOptions.last + increment);
    }
  }

  // Get current page data based on pagination
  List<T> get currentPageData {
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > dataList.length)
        ? dataList.length
        : start + rowsPerPage;
    return dataList.sublist(start, end);
  }

  // Sort data based on column index and order (ascending/descending)
  void sort<K>(Comparable<K> Function(T d) getField, int columnIndex, bool asc,
      VoidCallback setState) {
    dataList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return asc
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    ascending = asc;
    sortColumnIndex = columnIndex;
    paginationController.currentPage = 0; // Reset to first page after sorting
    currentPage = 0;
    _checkButtonState();
    _checkSelectAllState();
    setState();
  }

  // Toggle "select all" rows on the current page
  void toggleSelectAll(bool? value, VoidCallback setState) {
    isAllSelected = value ?? false;
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > dataList.length)
        ? dataList.length
        : start + rowsPerPage;
    for (int i = start; i < end; i++) {
      selectedRows[i] = isAllSelected;
    }
    _checkButtonState();
    setState();
  }

  // Toggle selection of individual row

  void toggleSingleRowSelection(int index, VoidCallback setState) {
    int actualIndex = currentPage * rowsPerPage + index;

    // Toggle logic: deselect if already selected
    if (selectedRows[actualIndex]) {
      selectedRows[actualIndex] = false;
    } else {
      // Deselect all first
      for (int i = 0; i < selectedRows.length; i++) {
        selectedRows[i] = false;
      }
      selectedRows[actualIndex] = true;
    }

    isAllSelected = false;
    _checkButtonState();
    setState();
  }

  // Dynamically update rows per page and reset pagination
  void updateRowsPerPage(int newRowsPerPage, VoidCallback setState) {
    rowsPerPage = newRowsPerPage;
    paginationController = PaginationController(
      rowsPerPage: rowsPerPage,
      totalRows: dataList.length,
      currentPage: 0,
      onPageChange: () {
        currentPage = paginationController.currentPage;
        _checkSelectAllState();
        _checkButtonState();
        setState();
      },
    );
    currentPage = 0;
    _checkSelectAllState();
    _checkButtonState();
    setState();
  }

  // Check if any rows are selected to enable action buttons
  void _checkButtonState() {
    isButtonEnabled = selectedRows.any((isSelected) => isSelected);
  }

  // Check if all rows on the current page are selected
  void _checkSelectAllState() {
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > dataList.length)
        ? dataList.length
        : start + rowsPerPage;
    isAllSelected =
        selectedRows.sublist(start, end).every((selected) => selected);
  }

  // Reset all selections (both rows and page)
  void resetSelections(VoidCallback setState) {
    selectedRows = List.generate(dataList.length, (_) => false);
    isAllSelected = false;
    isButtonEnabled = false;
    paginationController.currentPage = 0;
    currentPage = 0;
    setState();
  }
}

// PaginationController class for handling page changes
class PaginationController {
  int rowsPerPage;
  final int totalRows;
  int currentPage;
  final VoidCallback onPageChange;

  PaginationController({
    required this.rowsPerPage,
    required this.totalRows,
    required this.currentPage,
    required this.onPageChange,
  });

  void firstPage() {
    currentPage = 0;
    onPageChange();
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      onPageChange();
    }
  }

  void nextPage() {
    if ((currentPage + 1) * rowsPerPage < totalRows) {
      currentPage++;
      onPageChange();
    }
  }

  void lastPage() {
    currentPage = (totalRows / rowsPerPage).ceil() - 1;
    onPageChange();
  }
}

void showUnblockModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => UnblockDataModal(
      onCancel: () => Navigator.pop(dialogContext),
      onUnblock: () {
        Navigator.pop(dialogContext); // close dialog first

        // Delay to allow context pop before showing snackbar
        Future.delayed(Duration.zero, () {
          showSuccessSnackBar(
            context,
            title: 'Success!',
            message: 'User has been unblocked successfully.',
          );
        });
      },
    ),
  );
}

// Build Book Condition chip based on the status value
 Widget buildBooksStatusChip(String status) {
   final color = status == 'New' ? Colors.green : Colors.orange;
   return Container(
     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
     decoration: BoxDecoration(
       color: color.withOpacity(0.2),
       borderRadius: BorderRadius.circular(8),
     ),
     child: Text(status, style: TextStyle(color: color)),
   );
 }

// Build reservation status chip based on the status value
Widget buildReservationStatusChip(String status) {
  final color = status == 'Approved'
      ? Colors.green
      : status == 'Pending'
          ? Colors.orange
          : Colors.red;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.w500),
    ),
  );
}

Widget buildUserStatusChip(String status) {
  final color = status == 'Active' ? Colors.green : Colors.red;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(status, style: TextStyle(color: color)),
  );
}

// Build Barrowed Books Status chip based on the status value
 Widget buildBarrowedStatusChip(String status) {
   final Map<String, Color> statusColors = {
     'Pending': Colors.orange, // Awaiting approval
     'Approved': Colors.blue, // Approved and ready
     'Returned': Colors.green, // Successfully returned
     'Overdue': Colors.red, // Late return
     'Damaged': Colors.brown, // Item not in good condition
   };
 
   final color = statusColors[status] ?? Colors.grey;
 
   return Container(
     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
     decoration: BoxDecoration(
       color: color.withOpacity(0.2),
       borderRadius: BorderRadius.circular(8),
     ),
     child: Text(
       status,
       style: TextStyle(
         color: color,
         fontWeight: FontWeight.w500,
       ),
     ),
   );
 }
 
// Build sortable column label with an icon
Widget buildSortableColumnLabel(String label) {
  return Row(
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const Icon(Icons.unfold_more, size: 16),
    ],
  );
}
