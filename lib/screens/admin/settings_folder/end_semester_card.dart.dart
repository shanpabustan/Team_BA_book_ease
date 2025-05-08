import 'package:book_ease/base_url.dart';
import 'package:book_ease/modals/end_date_modal.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/admin/components/settings_components.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class EndSemesterCard extends StatefulWidget {
  const EndSemesterCard({super.key});

  @override
  _EndSemesterCardState createState() => _EndSemesterCardState();
}

class _EndSemesterCardState extends State<EndSemesterCard> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchSemesterEndDate();
  }

  Future<void> _fetchSemesterEndDate() async {
  try {
    final response = await Dio().get(
      '${ApiConfig.baseUrl}/admin/semester/end-date',
      options: Options(headers: {
        'Content-Type': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      final String? dateStr = response.data['data']?['value'];
      if (dateStr != null && dateStr.isNotEmpty) {
        setState(() {
          selectedDate = DateTime.parse(dateStr);
        });
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          title: "Error",
          message: "Failed to fetch semester end date.",
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnackBar(
        context,
        title: "Error",
        message: "Unable to fetch semester end date.",
      );
    }
    print("Fetch error: $e");
  }
}


  Future<void> _updateSemesterEndDate() async {
    if (selectedDate == null) return;

    final String formatted = DateFormat('yyyy-MM-dd').format(selectedDate!);

    try {
      final response = await Dio().put(
        '${ApiConfig.baseUrl}/admin/semester/end-date',
        data: {"value": formatted},
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        final message = response.data['message'];
        if (context.mounted) {
          showSuccessSnackBar(context, title: "Success!", message: message);
        }
      } else {
        if (context.mounted) {
          showErrorSnackBar(
            context,
            title: "Error",
            message: "Unexpected status: ${response.statusCode}",
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          title: "Error",
          message: "Failed to update semester end date.",
        );
      }
      print("API error: $e");
    }
  }

  Future<void> _selectEndSemesterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AdminColor.secondaryBackgroundColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AdminColor.secondaryBackgroundColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      final result = await showEndDateConfirmationDialog(context, picked);
      if (result == true) {
        setState(() {
          selectedDate = picked;
        });

        await _updateSemesterEndDate();

        if (context.mounted) {
          showSuccessSnackBar(
            context,
            title: 'Success!',
            message: 'Date set successfully.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = selectedDate != null
        ? DateFormat.yMMMMd().format(selectedDate!)
        : "No date set";

    return SettingsCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left section
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "End Semester",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Semester Deadline",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("Set or update the official semester end date."),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _selectEndSemesterDate(context);
                    },
                    icon: const Icon(Icons.calendar_today,
                        size: 18, color: Colors.white),
                    label: const Text("Set End Date"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColor.secondaryBackgroundColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right section
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "End Date",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: selectedDate != null
                            ? Colors.black87
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
