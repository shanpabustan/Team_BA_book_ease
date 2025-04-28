import 'package:book_ease/modals/unblock_data_modal.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:flutter/material.dart';

/// Table Controller to manage paginated, sortable, selectable table data
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
    _generateRowsPerPageOptions();
  }

  void _generateRowsPerPageOptions() {
    rowsPerPageOptions = [10];
    int increment = 10;
    int totalRows = dataList.length;
    while (rowsPerPageOptions.last < totalRows) {
      rowsPerPageOptions.add(rowsPerPageOptions.last + increment);
    }
  }

  List<T> get currentPageData {
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > dataList.length)
        ? dataList.length
        : start + rowsPerPage;
    return dataList.sublist(start, end);
  }

  void sort<K>(
    Comparable<K> Function(T d) getField,
    int columnIndex,
    bool asc,
    VoidCallback setState,
  ) {
    dataList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return asc
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    ascending = asc;
    sortColumnIndex = columnIndex;
    paginationController.currentPage = 0;
    currentPage = 0;
    _checkButtonState();
    _checkSelectAllState();
    setState();
  }

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

  void toggleSingleRowSelection(int index, VoidCallback setState) {
    int actualIndex = currentPage * rowsPerPage + index;

    if (selectedRows[actualIndex]) {
      selectedRows[actualIndex] = false;
    } else {
      for (int i = 0; i < selectedRows.length; i++) {
        selectedRows[i] = false;
      }
      selectedRows[actualIndex] = true;
    }

    isAllSelected = false;
    _checkButtonState();
    setState();
  }

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

  void _checkButtonState() {
    isButtonEnabled = selectedRows.any((isSelected) => isSelected);
  }

  void _checkSelectAllState() {
    int start = currentPage * rowsPerPage;
    int end = (start + rowsPerPage > dataList.length)
        ? dataList.length
        : start + rowsPerPage;
    isAllSelected =
        selectedRows.sublist(start, end).every((selected) => selected);
  }

  void resetSelections(VoidCallback setState) {
    selectedRows = List.generate(dataList.length, (_) => false);
    isAllSelected = false;
    isButtonEnabled = false;
    paginationController.currentPage = 0;
    currentPage = 0;
    setState();
  }

  void updateData(List<T> newData, VoidCallback setState) {
    dataList = newData;
    selectedRows = List.generate(dataList.length, (_) => false);
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
    _generateRowsPerPageOptions();
    _checkButtonState();
    _checkSelectAllState();
    setState();
  }
}

/// Controller for pagination navigation
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

/// Show unblock user modal
void showUnblockModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => UnblockDataModal(
      onCancel: () => Navigator.pop(dialogContext),
      onUnblock: () {
        Navigator.pop(dialogContext);
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

/// Build Books Status Chip (New/Old)
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

/// Build Reservation Status Chip (Approved/Pending/Rejected)
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

/// Build User Management Status Chip (Active/Inactive)
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

/// Build Borrowed Books Status Chip (Pending/Approved/Returned/Overdue/Damaged)
Widget buildBarrowedStatusChip(String status) {
  final Map<String, Color> statusColors = {
    'Pending': Colors.orange,
    'Approved': Colors.blue,
    'Returned': Colors.green,
    'Overdue': Colors.red,
    'Damaged': Colors.brown,
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

/// Build Sortable Column Label with an Icon
Widget buildSortableColumnLabel(String label) {
  return Row(
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const Icon(Icons.unfold_more, size: 16),
    ],
  );
}
