import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:flutter/material.dart';

class LibraryPolicyScreen extends StatelessWidget {
  const LibraryPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColor.lightGreenBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Library Policy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AdminColor.secondaryBackgroundColor,
              ),
            ),
            const SizedBox(height: 20),
            _policyCard(
              icon: Icons.menu_book,
              iconColor: Colors.lightBlueAccent,
              title: 'Book Reservation',
              description:
                  'Reservations are subject to book availability.\nIf a book is currently borrowed, the reservation will be queued, and users will be notified once it becomes available.',
            ),
            _policyCard(
              icon: Icons.menu_book_outlined,
              iconColor: Colors.lightGreen,
              title: 'Borrowing Guide',
              description:
                  'Each member is allowed to borrow up to 3 books at a time. The standard borrowing period for each book is 1 week.',
            ),
            _policyCard(
              icon: Icons.assignment_return,
              iconColor: Colors.teal,
              title: 'Returning',
              description:
                  'Books must be returned on or before the due date to avoid penalties.',
            ),
            _policyCard(
              icon: Icons.error_outline,
              iconColor: Colors.redAccent,
              title: 'Fines & Penalties',
              description:
                  'Late returns are subject to a fine of ₱15 per day, per book.\nLost or damaged books must be replaced or paid for at the current market value.',
            ),
            const Spacer(),
            _helpCard(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _policyCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpCard(BuildContext context) {
    return InkWell(
      onTap: () {
        // Action when user taps "Need help?"
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Redirecting to help...")),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: const [
            Expanded(
              child: Text(
                'Need help?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
