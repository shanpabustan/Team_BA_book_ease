import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:flutter/material.dart';

class LibraryPolicyScreen extends StatelessWidget {
  const LibraryPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColor.lightGreenBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Back Button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Library Policy',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AdminColor.secondaryBackgroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _policyCard(
                icon: Icons.menu_book,
                iconColor: Colors.lightBlueAccent,
                title: 'Book Reservation',
                description:
                    'Reserved books must be picked up at the library by the pickup date. If not collected within 24 hours after the pickup date, the reservation expires.',
              ),
              _policyCard(
                icon: Icons.menu_book_outlined,
                iconColor: Colors.lightGreen,
                title: 'Borrowing Guide',
                description:
                    'Students may borrow books based on availability. The borrowing period is 7 days. Books not returned by the due date are marked overdue.',
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
                    'Late returns are marked overdue. Lost or damaged books must be replaced or paid for. After 3 consecutive overdue returns, the student\'s account is blocked and login is disabled.',
              ),
              const SizedBox(height: 20),
              _helpCard(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _policyCard({
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

  static Widget _helpCard(BuildContext context) {
    return InkWell(
      onTap: () {
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
