import 'package:book_ease/screens/admin/barrowed_books/barrowed_return_controller.dart';
 import 'package:book_ease/widgets/admin_small_button_widget.dart';
 import 'package:flutter/material.dart';
 import 'package:book_ease/screens/admin/admin_theme.dart';
 
 class ReturnBookModal extends StatefulWidget {
   final Map<String, dynamic> returnData;
 
   const ReturnBookModal({super.key, required this.returnData});
 
   @override
   State<ReturnBookModal> createState() => _ReturnBookModalState();
 }
 
 class _ReturnBookModalState extends State<ReturnBookModal>
     with ReturnController {
   final _formKey = GlobalKey<FormState>();
 
   @override
   void initState() {
     super.initState();
     penaltyController.text =
         widget.returnData['penaltyAmount']?.toString() ?? '0';
   }
 
   void showSnackBar(String message) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text(message),
         duration: const Duration(seconds: 2),
       ),
     );
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
                   buildReadOnlyField(
                       'Borrow ID', widget.returnData['borrowID'] ?? ''),
                   buildReadOnlyField(
                       'Due Date', widget.returnData['dueDate'] ?? ''),
                   buildDatePickerField(context),
                   buildReadOnlyField('Book Condition (Before)',
                       widget.returnData['bookConditionBefore'] ?? ''),
                   buildConditionDropdown(),
                   buildPenaltyField(),
                   const SizedBox(height: 24),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       CustomSmallButton(
                         text: 'Cancel',
                         onPressed: () => Navigator.pop(context),
                         backgroundColor: Colors.white,
                         textColor: Colors.black,
                         borderColor: Colors.grey.shade300,
                         hoverColor: Colors.grey.shade200,
                       ),
                       const SizedBox(width: 12),
                       CustomSmallButton(
                         text: 'Returned',
                         onPressed: () {
                           if (_formKey.currentState!.validate() &&
                               selectedReturnDate != null &&
                               selectedCondition != null) {
                             Navigator.pop(context, {
                               'returnDate': selectedReturnDate,
                               'bookConditionAfter': selectedCondition,
                               'penaltyAmount': penaltyController.text,
                               'success': true,
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
 }