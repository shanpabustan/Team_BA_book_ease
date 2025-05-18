import 'package:flutter/services.dart';

class ISBNInputFormatter extends TextInputFormatter {
  static final _digitsOnly = RegExp(r'\d+');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-digit characters
    String digits =
        _digitsOnly.allMatches(newValue.text).map((e) => e.group(0)).join();

    // Limit to 13 digits max
    if (digits.length > 13) digits = digits.substring(0, 13);

    // Format parts: usually like 978-1-4028-9462-6
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if (i == 2 || i == 3 || i == 7 || i == 11) {
        if (i != digits.length - 1) buffer.write('-');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
