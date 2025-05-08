// search_admin.dart
import 'package:flutter/material.dart';

class SearchTable<T> extends StatefulWidget {
  final List<T> originalData;
  final List<String> searchableFields;
  final String Function(T)? getFieldValue;
  final void Function(List<T> filteredData) onFiltered;
  final String hintText;

  const SearchTable({
    Key? key,
    required this.originalData,
    required this.searchableFields,
    this.getFieldValue,
    required this.onFiltered,
    this.hintText = 'Search...',
  }) : super(key: key);

  @override
  State<SearchTable<T>> createState() => _SearchTableState<T>();
}

class _SearchTableState<T> extends State<SearchTable<T>> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      widget.onFiltered(List<T>.from(widget.originalData));
    } else {
      final filtered = widget.originalData.where((item) {
        if (item is Map) {
          return widget.searchableFields.any((field) {
            final value = item[field]?.toString().toLowerCase() ?? '';
            return value.contains(query);
          });
        } else if (widget.getFieldValue != null) {
          final value = widget.getFieldValue!(item).toLowerCase();
          return value.contains(query);
        }
        return false;
      }).toList();
      widget.onFiltered(filtered);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        height: 40,
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
