// import 'package:flutter/material.dart';
// import 'package:book_ease/models/borrowed_book.dart';
// import 'package:book_ease/services/borrowed_books_service.dart';
// import 'package:book_ease/modals/main_action_modal.dart';
// import 'package:provider/provider.dart';
// import 'package:book_ease/provider/user_data.dart';

// Future<void> cancelBorrowRequest({
//   required BuildContext context,
//   required BorrowedBook book,
//   required VoidCallback onSuccess,
// }) async {
//   final BorrowedBooksService borrowedBooksService = BorrowedBooksService();
//   final userData = Provider.of<UserData>(context, listen: false);
//   final String userId = userData.userID;

//   if (userId.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("User not logged in")),
//     );
//     return;
//   }

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext dialogContext) {
//       return CustomActionModal(
//         title: 'Cancel Reservation',
//         message:
//             'Are you sure you want to cancel your reservation for ${book.title}?',
//         iconPath: 'assets/icons/cancel_icon.svg',
//         onCancel: () => Navigator.pop(dialogContext),
//         onConfirm: () async {
//           try {
//             await borrowedBooksService.cancelBorrowRequest(book.bookId, userId);
//             onSuccess();
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Reservation cancelled successfully.")),
//             );
//           } catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Failed to cancel reservation: $e")),
//             );
//           }
//         },
//         confirmButtonText: 'Yes, Cancel',
//         cancelButtonText: 'No, Keep It',
//         buttonColor: Colors.red,
//         borderColor: const Color(0xFF1C0E4B),
//         iconData: Icons.cancel,
//         iconColor: Colors.red,
//       );
//     },
//   );
// }
