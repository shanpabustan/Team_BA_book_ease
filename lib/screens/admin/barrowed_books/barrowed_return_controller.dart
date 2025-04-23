import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

mixin ReturnController<T extends StatefulWidget> on State<T> {
  DateTime? selectedReturnDate;
  String? selectedCondition;
  bool isPenaltyEditable = false;
  final TextEditingController _penaltyController = TextEditingController();

  final List<String> conditionOptions = ['Good', 'Fair', 'Poor', 'Damaged'];

  // Public getters to access private fields
  TextEditingController get penaltyController => _penaltyController;
  bool get editablePenalty => isPenaltyEditable;

  // CALENDAR AREA
  Widget buildDatePickerField(BuildContext context) {
    final controller = TextEditingController(
      text: selectedReturnDate == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(selectedReturnDate!),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Return Date',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedReturnDate ?? DateTime.now(),
                firstDate: DateTime.now(), // 🔒 Disable past dates
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.teal, // Header background
                        onPrimary: Colors.white, // Header text
                        onSurface: Colors.black, // Calendar day text
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.teal, // Button text
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  selectedReturnDate = picked;
                });
                controller.text =
                    DateFormat('yyyy-MM-dd').format(picked); // 💡 Update text
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                readOnly: true,
                validator: (value) {
                  if (selectedReturnDate == null) {
                    return 'Please select a return date';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Select Return Date',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.teal,
                    size: 18,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: selectedReturnDate != null
                          ? Colors.teal
                          : Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: selectedReturnDate != null
                          ? Colors.teal
                          : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Colors.teal,
                      width: 1.5,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DIS-ABLE AREA
  Widget buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // BOOK CONDITION AFTER AREA
  Widget buildConditionDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Book Condition (After)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedCondition,
            onChanged: (value) {
              setState(() {
                selectedCondition = value;
                isPenaltyEditable = ['Fair', 'Poor', 'Damaged'].contains(value);
                if (!isPenaltyEditable) {
                  _penaltyController.text = '0';
                }
              });
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Please select a condition'
                : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.teal, width: 1),
              ),
            ),
            items: conditionOptions.map((condition) {
              return DropdownMenuItem<String>(
                value: condition,
                child: Text(condition),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // PENALTY AREA
  Widget buildPenaltyField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Penalty Amount',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _penaltyController,
            readOnly: !isPenaltyEditable,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(
                  r'^\d*\.?\d{0,2}')), // Allow numbers and up to two decimal places
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) {
                  return newValue.copyWith(text: '0.00');
                }
                if (!newValue.text.contains('.')) {
                  return newValue.copyWith(text: '${newValue.text}.00');
                }
                return newValue;
              })
            ],
            validator: (value) {
              if (isPenaltyEditable) {
                if (value == null || value.isEmpty) {
                  return 'Penalty amount is required';
                }
                final numValue = num.tryParse(value);
                if (numValue == null || numValue <= 1) {
                  return 'Enter a number greater than 1';
                }
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: isPenaltyEditable ? Colors.white : Colors.grey[200],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isPenaltyEditable ? Colors.teal : Colors.grey.shade400,
                ),
              ),
              focusedBorder: isPenaltyEditable
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 1),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
