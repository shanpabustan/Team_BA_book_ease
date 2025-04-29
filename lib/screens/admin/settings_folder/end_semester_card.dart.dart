import 'package:book_ease/modals/end_date_modal.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/admin/components/settings_components.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndSemesterCard extends StatefulWidget {
  const EndSemesterCard({super.key});

  @override
  _EndSemesterCardState createState() => _EndSemesterCardState();
}

class _EndSemesterCardState extends State<EndSemesterCard> {
  DateTime? selectedDate;

  // Function to show Date Picker modal
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
      // Await result from confirmation dialog
      final result = await showEndDateConfirmationDialog(context, picked);
      if (result == true) {
        setState(() {
          selectedDate = picked;
        });
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
            // 🔹 Left side content
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
            // 🔹 Right side date display
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "End Date",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6), // light grey background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD1D5DB), // border color
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
