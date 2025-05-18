import 'package:book_ease/modals/main_action_modal.dart';
import 'package:flutter/material.dart';

void showReservationConfirmationModal(BuildContext context,
    {required VoidCallback onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomActionModal(
        title: 'Confirm Reservation',
        message:
            'Are you sure you want to reserve this book? This action cannot be undone.',
        iconPath: 'assets/icons/book_reservation_icon.svg',
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          onConfirm(); // Call the passed reservation logic
        },
        confirmButtonText: 'Confirm',
        cancelButtonText: 'Cancel',
        buttonColor: Colors.green,
        borderColor: Color(0xFF1C0E4B),
        iconData: Icons.book,
        iconColor: Colors.green,
      );
    },
  );
}
