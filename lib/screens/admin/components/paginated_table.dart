import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int rowsPerPage;
  final int totalRows;
  final ValueChanged<int> onRowsPerPageChanged;
  final VoidCallback onFirstPage;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onLastPage;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.rowsPerPage,
    required this.totalRows,
    required this.onRowsPerPageChanged,
    required this.onFirstPage,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onLastPage,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalRows / rowsPerPage).ceil();
    final start = totalRows == 0 ? 0 : (currentPage * rowsPerPage) + 1;
    final end = ((currentPage + 1) * rowsPerPage).clamp(0, totalRows);

    final List<int> availableRowsPerPageOptions = _generateRowOptions();

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 0, horizontal: 16.0), // Added vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('Rows per page: ', style: TextStyle(fontSize: 13)),
              DropdownButton<int>(
                value: rowsPerPage,
                onChanged: (value) {
                  if (value != null) {
                    onRowsPerPageChanged(value);
                  }
                },
                items: availableRowsPerPageOptions.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString(),
                        style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
              ),
              const SizedBox(width: 16),
              Text('$start–$end of $totalRows',
                  style: const TextStyle(fontSize: 13)),
            ],
          ),
          Row(
            children: [
              Tooltip(
                message: 'Go to first page',
                child: IconButton(
                  icon: const Icon(Icons.first_page),
                  onPressed: currentPage > 0 ? onFirstPage : null,
                ),
              ),
              Tooltip(
                message: 'Go to previous page',
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 0 ? onPreviousPage : null,
                ),
              ),
              Tooltip(
                message: 'Go to next page',
                child: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentPage < totalPages - 1 ? onNextPage : null,
                ),
              ),
              Tooltip(
                message: 'Go to last page',
                child: IconButton(
                  icon: const Icon(Icons.last_page),
                  onPressed: currentPage < totalPages - 1 ? onLastPage : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<int> _generateRowOptions() {
    final options = <int>{10}; // Default included
    if (totalRows > 0) {
      for (int i = 5; i <= totalRows; i += 5) {
        options.add(i);
      }
      options.add(totalRows); // Always include totalRows as an option
    }
    return options.toList()..sort();
  }
}
