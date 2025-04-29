import 'package:flutter/material.dart';

class PasswordCriteriaWidget extends StatelessWidget {
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasMinLength;

  const PasswordCriteriaWidget({
    Key? key,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasMinLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 2, color: Colors.redAccent),
        const SizedBox(height: 8),
        const Text("Weak password. Must contain:",
            style: TextStyle(color: Colors.red)),
        _buildPasswordCriteria("At least 1 uppercase", hasUppercase),
        _buildPasswordCriteria("At least 1 lowercase", hasLowercase),
        _buildPasswordCriteria("At least 1 number", hasNumber),
        _buildPasswordCriteria("At least 8 characters", hasMinLength),
      ],
    );
  }

  Widget _buildPasswordCriteria(String text, bool passed) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.cancel,
          color: passed ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
