import 'dart:io';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddBookFormContent extends StatefulWidget {
  final TextEditingController bookIdController;
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController yearController;
  final TextEditingController versionController;
  final TextEditingController isbnController;
  final TextEditingController totalCopiesController;
  final TextEditingController sectionController;
  final TextEditingController shelfLocationController;
  final TextEditingController descriptionController;
  final TextEditingController customCategoryController;

  final String? selectedCategory;
  final String? selectedCondition;
  final File? pickedImage;

  final List<String> categories;
  final List<String> conditions;

  final GlobalKey<FormState> formKey;

  final void Function() onSave;
  final void Function() onClear;
  final void Function() onPickImage;
  final void Function(String) onCategoryChanged;

  const AddBookFormContent({
    super.key,
    required this.bookIdController,
    required this.titleController,
    required this.authorController,
    required this.yearController,
    required this.versionController,
    required this.isbnController,
    required this.totalCopiesController,
    required this.sectionController,
    required this.shelfLocationController,
    required this.descriptionController,
    required this.customCategoryController,
    required this.selectedCategory,
    required this.selectedCondition,
    required this.pickedImage,
    required this.categories,
    required this.conditions,
    required this.formKey,
    required this.onSave,
    required this.onClear,
    required this.onPickImage,
    required this.onCategoryChanged,
  });

  @override
  _AddBookFormContentState createState() => _AddBookFormContentState();
}

  class _AddBookFormContentState extends State<AddBookFormContent> {
    @override
    Widget build(BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Scaffold(
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header / AppBar Style
                  _buildHeader(context),

                  // Scrollable Content
                  _buildFormContent(context),
                ],
              ),
            ),
          ),
        ),
      );
    }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: AdminColor.secondaryBackgroundColor,
              child: const Icon(Icons.close, color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Add Book',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: AdminFontSize.heading,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN
                _buildLeftColumn(context),

                const SizedBox(width: 32),

                // RIGHT COLUMN
                _buildRightColumn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onPickImage,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('Upload Image'),
                  const SizedBox(height: 12),
                  widget.pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.network(
                                  widget.pickedImage!.path,
                                  height: 160,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  widget.pickedImage!,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : const Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey,
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
              'Category', widget.selectedCategory, widget.categories),
          if (widget.selectedCategory == 'Others') ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.customCategoryController,
              decoration: InputDecoration(
                labelText: 'Enter Custom Category',
                floatingLabelStyle: const TextStyle(
                  color: AdminColor.secondaryBackgroundColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AdminColor.secondaryBackgroundColor,
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (widget.selectedCategory == 'Others' &&
                    (value == null || value.trim().isEmpty)) {
                  return 'Please enter a custom category';
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 16),
          _buildDropdown(
              'Book Condition', widget.selectedCondition, widget.conditions),
          const SizedBox(height: 16),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items) {
  // Provide a default value if the value is null
  final selectedValue = value ?? items.first; // Default to the first item if null

  return DropdownButtonFormField<String>(
    value: selectedValue,
    items: items
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
        .toList(),
    decoration: InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(color: AdminColor.secondaryBackgroundColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AdminColor.secondaryBackgroundColor),
      ),
      border: const OutlineInputBorder(),
    ),
    onChanged: (newValue) {
      if (newValue != null) {
        widget.onCategoryChanged(newValue);  // Safeguard against null
      }
    },
    validator: (value) => value == null ? '$label is required' : null,
  );
}


  Widget _buildDescriptionField() {
    return TextFormField(
      controller: widget.descriptionController,
      maxLines: 8,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Write here...',
        floatingLabelStyle:
            const TextStyle(color: AdminColor.secondaryBackgroundColor),
        alignLabelWithHint: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 43, horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AdminColor.secondaryBackgroundColor),
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Description is required' : null,
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Information',
              style: TextStyle(
                fontSize: AdminFontSize.subHeading,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Book ID', widget.bookIdController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            _buildTextField('Title', widget.titleController),
            _buildTextField('Author', widget.authorController),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Year Published',
                    widget.yearController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Version',
                    widget.versionController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'))
                    ],
                  ),
                ),
              ],
            ),
            _buildTextField('ISBN', widget.isbnController),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Total Copies',
                    widget.totalCopiesController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                      'Library Section', widget.sectionController),
                ),
              ],
            ),
            _buildTextField('Shelf Location', widget.shelfLocationController),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Clear All',
                  onPressed: widget.onClear,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: 'Save',
                  onPressed: widget.onSave,
                  backgroundColor: AdminColor.secondaryBackgroundColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle:
              const TextStyle(color: AdminColor.secondaryBackgroundColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AdminColor.secondaryBackgroundColor),
          ),
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? '$label is required' : null,
      ),
    );
  }
}
