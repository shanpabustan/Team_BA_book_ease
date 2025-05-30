import 'package:book_ease/screens/admin/barrowed_books/barrowed_books_data.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/barrowed_books/barrowed_return_controller.dart';
import 'package:book_ease/widgets/admin_small_button_widget.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:intl/intl.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';

class ReturnBookModal extends StatefulWidget {
  final BorrowedBookAdmin returnData;

  const ReturnBookModal({super.key, required this.returnData});

  @override
  State<ReturnBookModal> createState() => _ReturnBookModalState();
}

class _ReturnBookModalState extends State<ReturnBookModal> with ReturnController {
  final _formKey = GlobalKey<FormState>();
  bool isReturning = false;
  DateTime? selectedReturnDate;

  @override
  void initState() {
    super.initState();
    penaltyController.text = widget.returnData.penalty.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Return Book',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),

                buildReadOnlyField('Borrow ID', widget.returnData.borrowID.toString()),
                buildReadOnlyField(
                  'Due Date',
                  widget.returnData.dueDate != null
                      ? DateFormat('MM-dd-yy').format(DateTime.parse(widget.returnData.dueDate!))
                      : 'N/A',
                ),
                buildReadOnlyField(
                  'Return Date',
                  selectedReturnDate != null
                      ? DateFormat('MM-dd-yy hh:mm a').format(selectedReturnDate!)
                      : 'Will be set upon return',
                ),
                buildReadOnlyField('Book Condition (Before)', widget.returnData.conditionBefore ?? 'N/A'),
                buildConditionDropdown(),
                buildPenaltyField(),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomSmallButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      borderColor: Colors.grey.shade300,
                      hoverColor: Colors.grey.shade200,
                    ),
                    const SizedBox(width: 12),
                    CustomSmallButton(
                      text: 'Returned',
                      onPressed: () async {
                        // Begin validation
                        if (!_formKey.currentState!.validate()) {
                          return showWarningSnackBar(
                            context,
                            title: "Validation Error",
                            message: "Please check all required fields",
                          );
                        }

                        if (selectedCondition == null) {
                          return showWarningSnackBar(
                            context,
                            title: "Missing Information",
                            message: "Please select the book's condition",
                          );
                        }

                        final penaltyAmount = double.tryParse(penaltyController.text) ?? 0.0;
                        if (selectedCondition == 'Damaged' && penaltyAmount <= 0) {
                          return showWarningSnackBar(
                            context,
                            title: "Validation Error",
                            message: "Penalty amount is required for damaged books",
                          );
                        }

                        setState(() {
                          isReturning = true;
                          selectedReturnDate = DateTime.now();
                        });

                        try {
                          final response = await Dio().put(
                            '${ApiConfig.baseUrl}/admin/return-book/${widget.returnData.borrowID}',
                            data: {
                              "book_condition_after": selectedCondition,
                              "penalty_amount": penaltyAmount,
                              "return_date": selectedReturnDate!.toIso8601String(),
                            },
                          );

                          if (response.statusCode == 200) {
                            if (!mounted) return;
                            Navigator.pop(context, {
                              'returnDate': selectedReturnDate,
                              'bookConditionAfter': selectedCondition,
                              'penaltyAmount': penaltyController.text,
                              'success': true,
                            });
                          } else {
                            throw Exception(response.data['message'] ?? 'Failed to return book');
                          }
                        } on DioException catch (e) {
                          final errorMessage = e.response?.data?['message'] ??
                              e.message ??
                              'Network error occurred';
                          if (!mounted) return;
                          showErrorSnackBar(
                            context,
                            title: "Return Failed",
                            message: errorMessage,
                          );
                          debugPrint("ReturnBookModal DioError: ${e.toString()}");
                        } catch (e) {
                          if (!mounted) return;
                          showErrorSnackBar(
                            context,
                            title: "Error",
                            message: e.toString().replaceAll('Exception: ', ''),
                          );
                          debugPrint("ReturnBookModal Error: ${e.toString()}");
                        } finally {
                          if (mounted) {
                            setState(() {
                              isReturning = false;
                            });
                          }
                        }
                      },
                      backgroundColor: AdminColor.secondaryBackgroundColor,
                      textColor: Colors.white,
                      borderColor: AdminColor.secondaryBackgroundColor,
                      hoverColor: AdminColor.secondaryBackgroundColor.withOpacity(0.85),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
