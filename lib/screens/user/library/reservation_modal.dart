import 'package:book_ease/base_url.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

void reserveBook(
  BuildContext rootContext, // 👈 Correct context for ScaffoldMessenger
  int bookId,
  String userId,
  DateTime pickupDate,
) async {
  print("Reserving book with:");
  print("Book ID: $bookId");
  print("User ID: $userId");
  print("Pickup Date: ${pickupDate.toIso8601String()}");

  String formattedPickupDate = "${pickupDate.toUtc().toIso8601String().split(".")[0]}Z";

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
        // ✅ Success
        ScaffoldMessenger.of(rootContext).showSnackBar(
          SnackBar(content: Text("✅ $message")),
        );
        Fluttertoast.showToast(
        msg: "📚 $message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFF008080), // Solid teal hex
        textColor: Colors.white,
        fontSize: 16.0,
        );
        // Optionally, you can navigate to another screen or perform other actions here
      
      } else {
        // ⚠️ Handled error with 200 response
        ScaffoldMessenger.of(rootContext).showSnackBar(
          SnackBar(content: Text("⚠️ $message")),
        );
      }
    } else {
      // 🔴 Unexpected non-200/201 response
      ScaffoldMessenger.of(rootContext).showSnackBar(
        SnackBar(content: Text("❌ Something went wrong. Please try again.")),
      );
    }
  } catch (e) {
    String errorMessage = "❌ Failed to reserve book.";

    if (e is DioException) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMessage = "⚠️ ${data['message']}";
        }
      } else {
        errorMessage = "❌ Server unreachable. Please try again.";
      }
    }

    ScaffoldMessenger.of(rootContext).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}


void showReservationModal(
  BuildContext rootContext,
  String bookTitle,
  int copies,
  int bookId,
  String userId,
)

{
  DateTime? preferredPickupDate;
  final dateFormat = DateFormat('yyyy-MM-dd');

  showDialog(
    context: rootContext,
    builder: (BuildContext dialogContext) {

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("📚 Reserve Book", style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📖 Title:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(bookTitle, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Text("📦 Available Copies:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("$copies", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              preferredPickupDate = pickedDate;
                            });
                            print("Selected pickup date: ${dateFormat.format(pickedDate)}");
                          } else {
                            print("No pickup date selected.");
                          }
                      },
                      icon: Icon(Icons.date_range),
                      label: Text("Select Pickup Date"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (preferredPickupDate != null)
                    Text("🗓️ Pickup Date: ${dateFormat.format(preferredPickupDate!)}"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (preferredPickupDate == null) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text("Please select a valid pickup date")),
                    );
                    return;
                  }
                  reserveBook(rootContext, bookId, userId, preferredPickupDate!); // ✅ use outer context
                  Navigator.of(dialogContext).pop();
                },
                child: Text("Reserve", style: TextStyle(color: Colors.teal)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
            ],
          );
        },
      );
    },
  );
}
