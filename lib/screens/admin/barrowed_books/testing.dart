import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:intl/intl.dart';

class ReturnBookModal extends StatefulWidget {
  final Map<String, dynamic> returnData;
  const ReturnBookModal({super.key, required this.returnData});

  @override
  State<ReturnBookModal> createState() => _ReturnBookModalState();
}

class _ReturnBookModalState extends State<ReturnBookModal> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedReturnDate;
  String? selectedCondition;
  bool isPenaltyEditable = false;
  final TextEditingController _penaltyController = TextEditingController();

  final List<String> conditionOptions = [
    'New',
    'Good',
    'Fair',
    'Poor',
    'Damaged'
  ];

  @override
  void initState() {
    super.initState();
    _penaltyController.text =
        widget.returnData['penaltyAmount']?.toString() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Return Book',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildReadOnlyField(
                      'Borrow ID', widget.returnData['borrowID'] ?? ''),
                  _buildReadOnlyField(
                      'Due Date', widget.returnData['dueDate'] ?? ''),
                  _buildDatePickerField(context),
                  _buildReadOnlyField('Book Condition (Before)',
                      widget.returnData['bookConditionBefore'] ?? ''),
                  _buildConditionDropdown(),
                  _buildPenaltyField(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        borderColor: Colors.grey.shade300,
                        hoverColor: Colors.grey.shade200,
                      ),
                      const SizedBox(width: 12),
                      CustomButton(
                        text: 'Returned',
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              selectedReturnDate != null &&
                              selectedCondition != null) {
                            Navigator.pop(context, {
                              'returnDate': selectedReturnDate,
                              'bookConditionAfter': selectedCondition,
                              'penaltyAmount': _penaltyController.text,
                            });
                          }
                        },
                        backgroundColor: AdminColor.secondaryBackgroundColor,
                        textColor: Colors.white,
                        borderColor: AdminColor.secondaryBackgroundColor,
                        hoverColor: AdminColor.secondaryBackgroundColor
                            .withOpacity(0.85),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Return Date',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  selectedReturnDate = picked;
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: TextEditingController(
                  text: selectedReturnDate == null
                      ? ''
                      : DateFormat('yyyy-MM-dd').format(selectedReturnDate!),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.calendar_today),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: selectedReturnDate != null
                            ? Colors.teal
                            : Colors.grey.shade400,
                        width: 1,
                      )),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: selectedReturnDate != null
                          ? Colors.teal
                          : Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.teal, width: 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
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

  Widget _buildConditionDropdown() {
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

  Widget _buildPenaltyField() {
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
            keyboardType: TextInputType.number,
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

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color hoverColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return hoverColor;
            }
            return backgroundColor;
          }),
          foregroundColor: WidgetStateProperty.all(textColor),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor),
          )),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
