import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isButtonEnabled;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.isButtonEnabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isButtonEnabled ? onPressed : null,
      icon: Icon(icon, color: isButtonEnabled ? color : Colors.grey),
      label: Text(
        label,
        style: TextStyle(color: isButtonEnabled ? color : Colors.grey),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isButtonEnabled ? color : Colors.grey),
        backgroundColor: isButtonEnabled ? null : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

class ActionButtonRow extends StatelessWidget {
  final bool isButtonEnabled;
  final VoidCallback onPdfPressed;
  final VoidCallback onExcelPressed;

  const ActionButtonRow({
    Key? key,
    required this.isButtonEnabled,
    required this.onPdfPressed,
    required this.onExcelPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          icon: Icons.picture_as_pdf,
          label: 'PDF',
          color: Colors.red,
          isButtonEnabled: isButtonEnabled,
          onPressed: onPdfPressed,
        ),
        const SizedBox(width: 16),
        ActionButton(
          icon: Icons.file_copy,
          label: 'Excel',
          color: Colors.green,
          isButtonEnabled: isButtonEnabled,
          onPressed: onExcelPressed,
        ),
      ],
    );
  }
}
