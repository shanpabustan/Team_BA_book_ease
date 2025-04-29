
import 'package:book_ease/screens/admin/barrowed_books/barrowed_books_data.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/barrowed_books/barrowed_return_controller.dart';
import 'package:book_ease/widgets/admin_small_button_widget.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:intl/intl.dart';


class ReturnBookModal extends StatefulWidget {
  final BorrowedBookAdmin returnData;

  const ReturnBookModal({super.key, required this.returnData});

  @override
  State<ReturnBookModal> createState() => _ReturnBookModalState();
}

class _ReturnBookModalState extends State<ReturnBookModal> with ReturnController {
  final _formKey = GlobalKey<FormState>();
  bool isReturning = false;


  @override
  void initState() {
    super.initState();
    penaltyController.text = widget.returnData.penalty.toString();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
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


                  buildDatePickerField(context),

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
                          if (_formKey.currentState!.validate() &&
                              selectedReturnDate != null &&
                              selectedCondition != null) {
                            
                            try {
                              final borrowId = widget.returnData.borrowID;
                              final response = await Dio().put(
                                '${ApiConfig.baseUrl}/admin/return-book/$borrowId',
                                data: {
                                  "book_condition_after": selectedCondition,
                                  "penalty_amount": double.tryParse(penaltyController.text) ?? 0.0,
                                },
                              );

                              if (response.statusCode == 200) {
                                Navigator.pop(context, {
                                  'returnDate': selectedReturnDate,
                                  'bookConditionAfter': selectedCondition,
                                  'penaltyAmount': penaltyController.text,
                                  'success': true,
                                });
                                showSnackBar("Book returned successfully!");
                              } else {
                                showSnackBar("Return failed: ${response.data['message']}");
                              }
                            } catch (e) {
                              debugPrint("ReturnBookModal Error: $e");
                              showSnackBar("Something went wrong. Please try again.");
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
      ),
    );
  }
}
