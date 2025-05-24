import 'package:book_ease/base_url.dart';
import 'package:book_ease/modals/reserve_book_user_modal.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/screens/user/app_text_styles.dart';

void reserveBook(
  BuildContext rootContext,
  int bookId,
  String userId,
  DateTime pickupDate,
) async {
  print("Reserving book with:");
  print("Book ID: $bookId");
  print("User ID: $userId");
  print("Pickup Date: ${pickupDate.toIso8601String()}");

  String formattedPickupDate = "${pickupDate.toIso8601String().split(".")[0]}Z";

  try {
    final response = await Dio().post(
      '${ApiConfig.baseUrl}/reserve/reserve-book',
      data: {
        "book_id": bookId,
        "user_id": userId,
        "preferred_pickup_date": formattedPickupDate,
      },
    );

    print("Response: ${response.data}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final retCode = response.data['retCode'];
      final message = response.data['message'];

      if (retCode == '201') {
        showSuccessSnackBar(
          rootContext,
          title: 'Success',
          message: message,
        );
      } else {
        showWarningSnackBar(
          rootContext,
          title: 'Warning',
          message: message,
        );
      }
    } else {
      showErrorSnackBar(
        rootContext,
        title: 'Error',
        message: 'Something went wrong. Please try again.',
      );
    }
  } catch (e) {
    String title = 'Reservation Failed';
    String message = "Failed to reserve book.";

    if (e is DioException) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          message = data['message'];
          showErrorSnackBar(
            rootContext,
            title: title,
            message: message,
          );
          return;
        }
      } else {
        message = "Server unreachable. Please try again.";
      }
    }

    showErrorSnackBar(
      rootContext,
      title: title,
      message: message,
    );
  }
}

void showReservationModal(
  BuildContext rootContext,
  String bookTitle,
  int copies,
  int bookId,
  String userId,
) {
  DateTime? preferredPickupDate;
  final dateFormat = DateFormat('MMM dd yyyy');
  Widget _infoRow(IconData icon, String label, String value,
      {TextStyle? textStyle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AdminColor.secondaryBackgroundColor),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: textStyle ??
                  AppTextStyles.body.copyWith(color: Colors.black87),
              children: [
                TextSpan(
                  text: "$label ",
                  style: (textStyle ?? AppTextStyles.body).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  showDialog(
    context: rootContext,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.book_online,
                    color: AdminColor.secondaryBackgroundColor),
                SizedBox(width: 8),
                Text("Reserve Book", style: AppTextStyles.pageTitle),
              ],
            ),
            content: SingleChildScrollView(
              child: Container(
                width: 400,
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _infoRow(Icons.menu_book, "Title:", bookTitle,
                        textStyle: AppTextStyles.subTitle),
                    SizedBox(height: 12),
                    _infoRow(Icons.inventory, "Available Copies:", "$copies",
                        textStyle: AppTextStyles.subTitle),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        AdminColor.secondaryBackgroundColor,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          AdminColor.secondaryBackgroundColor,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            setState(() {
                              preferredPickupDate = pickedDate;
                            });
                          }
                        },
                        icon: Icon(Icons.date_range, color: Colors.white),
                        label: Text("Select Pickup Date",
                            style: AppTextStyles.button
                                .copyWith(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminColor.secondaryBackgroundColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(double.infinity, 48),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (preferredPickupDate != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: AdminColor.secondaryBackgroundColor,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Pickup Date: ",
                                    style: AppTextStyles.body
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        dateFormat.format(preferredPickupDate!),
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // optional: prevents text from overflowing with "..."
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text("Cancel",
                        style:
                            AppTextStyles.button.copyWith(color: Colors.black)),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (preferredPickupDate == null) {
                        showWarningSnackBar(
                          dialogContext,
                          title: 'Date Not Selected',
                          message:
                              'Please select a valid pickup date before reserving the book.',
                        );
                        return;
                      }

                      Navigator.of(dialogContext).pop(); // Close initial dialog

                      // Show the reusable confirmation modal
                      showReservationConfirmationModal(
                        rootContext,
                        onConfirm: () {
                          reserveBook(
                            rootContext,
                            bookId,
                            userId,
                            preferredPickupDate!,
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColor.secondaryBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    ),
                    child: Text("Reserve",
                        style:
                            AppTextStyles.button.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
