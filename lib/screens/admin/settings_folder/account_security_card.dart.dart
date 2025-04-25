import 'package:book_ease/screens/admin/settings_folder/admin_change_password_modal.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // For Timer

import '../components/settings_components.dart';

class AccountSecurityCard extends StatefulWidget {
  const AccountSecurityCard({super.key});

  @override
  _AccountSecurityCardState createState() => _AccountSecurityCardState();
}

class _AccountSecurityCardState extends State<AccountSecurityCard> {
  DateTime _lastPasswordChange = DateTime.now()
      .subtract(const Duration(days: 60)); // Default to 2 months ago
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadLastPasswordChange();
    // Start a timer to refresh the time every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        // Explicitly update the last password change time
        _lastPasswordChange = _lastPasswordChange;
      });
    });
  }

  // Load the last password change time from shared_preferences
  Future<void> _loadLastPasswordChange() async {
    final prefs = await SharedPreferences.getInstance();
    final lastChanged = prefs.getString('lastPasswordChange');

    if (lastChanged != null) {
      setState(() {
        _lastPasswordChange = DateTime.parse(lastChanged);
      });
    }
  }

  // Save the last password change time to shared_preferences
  Future<void> _saveLastPasswordChange() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'lastPasswordChange', _lastPasswordChange.toIso8601String());
  }

  // This function calculates the time difference from the current time to the last password change time
  String getTimeAgo(DateTime lastChanged) {
    final Duration diff = DateTime.now().difference(lastChanged);

    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return "$years year${years > 1 ? 's' : ''} ago";
    } else if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return "$months month${months > 1 ? 's' : ''} ago";
    } else if (diff.inDays >= 1) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else if (diff.inMinutes >= 1) {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Don't forget to cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Account Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              "Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Last changed: ${getTimeAgo(_lastPasswordChange)}", // Dynamic time ago
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => PasswordChangeForm(
                    onSubmit: (current, newPass) {
                      // You can perform API call here if needed
                    },
                  ),
                );

                if (result != null && result['success'] == true) {
                  setState(() {
                    _lastPasswordChange =
                        DateTime.now(); // Update the last password change time
                  });

                  // Save the updated password change time
                  await _saveLastPasswordChange();

                  if (context.mounted) {
                    showSuccessSnackBar(
                      context,
                      title: 'Success!',
                      message: 'Password changed successfully.',
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColor.secondaryBackgroundColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Change password"),
            ),
          ],
        ),
      ),
    );
  }
}
