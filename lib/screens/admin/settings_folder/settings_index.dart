import 'package:book_ease/screens/admin/settings_folder/account_security_card.dart.dart';
import 'package:book_ease/screens/admin/settings_folder/end_semester_card.dart.dart';
import 'package:book_ease/screens/admin/settings_folder/profile_card.dart.dart';
import 'package:flutter/material.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // ⬅️ Transparent background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Top Row: AccountSecurityCard + EndSemesterCard
              Row(
                children: const [
                  Expanded(child: AccountSecurityCard()),
                  SizedBox(width: 16),
                  Expanded(child: EndSemesterCard()),
                ],
              ),
              const SizedBox(height: 24),
              // Bottom: ProfileCard expands to remaining space
              Expanded(
                child: ProfileCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
