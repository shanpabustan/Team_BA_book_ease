// checkbox_style.dart
import 'package:flutter/material.dart';

const Color tealColor = Color(0xFF008080);

CheckboxListTile customCheckbox({
  required bool value,
  required ValueChanged<bool?> onChanged,
}) {
  return CheckboxListTile(
    title: const Text('Select'),
    value: value,
    onChanged: onChanged,
    activeColor: tealColor, // Checkbox active color (when checked)
    checkColor: Colors.white, // Color of the check icon
    controlAffinity: ListTileControlAffinity.leading,
  );
}
