import 'dart:convert';
import 'dart:io';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/admin/managebook/reusable_form.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:book_ease/modals/save_validation_modal.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class EditBookForm extends StatefulWidget {
  final Map<String, dynamic> book;

  const EditBookForm({Key? key, required this.book}) : super(key: key);

  @override
  State<EditBookForm> createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _bookIdController;
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _yearController;
  late TextEditingController _versionController;
  late TextEditingController _isbnController;
  late TextEditingController _totalCopiesController;
  late TextEditingController _sectionController;
  late TextEditingController _shelfLocationController;
  late TextEditingController _descriptionController;
  late TextEditingController _customCategoryController;

  // Form state variables
  String? _selectedCategory;
  String? _selectedCondition;
  File? _pickedImage;
  Uint8List? _webImageBytes;

  // Constants
  final List<String> _baseCategories = [
    'Information System',
    'Computer Science',
    'Engineering',
    'Mathematics',
    'Fiction',
    'Non-Fiction',
    'Textbooks',
    'Reference Materials',
    'Children’s Books',
    'Young Adult (YA)',
    'Science & Technology',
    'History & Social Studies',
    'Biographies',
    'Comics & Graphic Novels',
    'Others',
  ];
  final List<String> conditions = ['New', 'Used'];
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories = List.from(_baseCategories);

    // Initialize controllers with book data
    _initializeControllers();
  }

  void _initializeControllers() {
    _bookIdController = TextEditingController(text: widget.book['bookId']);
    _titleController = TextEditingController(text: widget.book['title']);
    _authorController = TextEditingController(text: widget.book['author']);
    _yearController = TextEditingController(text: widget.book['year']);
    _versionController = TextEditingController(text: widget.book['version']);
    _isbnController = TextEditingController(text: widget.book['isbn']);
    _totalCopiesController = TextEditingController(text: widget.book['totalCopies']);
    _sectionController = TextEditingController(text: widget.book['section']);
    _shelfLocationController =
        TextEditingController(text: widget.book['shelfLocation']);
    _descriptionController =
        TextEditingController(text: widget.book['description']);
    _customCategoryController = TextEditingController();

    _selectedCategory = widget.book['category'];
    _selectedCondition = widget.book['condition'];
    if (widget.book['image'] != null) {
      _pickedImage = File(widget.book['image']);
    }
  }

  // Method to pick an image
  void _pickImage() async {
    // Check permissions only if not on web
    if (!kIsWeb) {
      var status = await Permission.photos.request();
      if (!status.isGranted) {
        showWarningSnackBar(
          context,
          title: 'Permission Denied',
          message:
              'Photo permission is not granted. Please allow access to your photos.',
        );
        return;
      }
    }

    // Pick an image using FilePicker
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          if (kIsWeb) {
            _webImageBytes = result.files.single.bytes;
            _pickedImage = File(''); // Dummy to indicate an image is picked
          } else {
            _pickedImage = File(result.files.single.path!);
          }
        });
      }
    } else {
      showWarningSnackBar(
        context,
        title: 'No Image Selected',
        message: 'Please select an image to upload.',
      );
    }
  }

  void _clearAll() {
    _formKey.currentState?.reset();
    _bookIdController.clear();
    _titleController.clear();
    _authorController.clear();
    _yearController.clear();
    _versionController.clear();
    _isbnController.clear();
    _totalCopiesController.clear();
    _sectionController.clear();
    _shelfLocationController.clear();
    _descriptionController.clear();
    _customCategoryController.clear();
    _pickedImage = null;
    setState(() {
      _selectedCategory = null;
      _selectedCondition = null;
    });
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_pickedImage == null &&
          _webImageBytes == null &&
          widget.book['image'] == null) {
        showWarningSnackBar(
          context,
          title: 'Image Required',
          message: 'Please upload an image to proceed.',
        );
        return;
      }

      if (_selectedCategory == 'Others') {
        final customCategory = _customCategoryController.text.trim();
        if (customCategory.isEmpty) {
          showWarningSnackBar(
            context,
            title: 'Category Required',
            message: 'Please enter a custom category name.',
          );
          return;
        }

        if (!_categories.contains(customCategory)) {
          setState(() {
            _categories.insert(_categories.length - 1, customCategory);
          });
        }

        _selectedCategory = customCategory;
      } else {
        _customCategoryController.clear();
      }

      Uint8List? bytes;
      if (kIsWeb) {
        if (_webImageBytes == null && widget.book['image'] == null) {
          showWarningSnackBar(
            context,
            title: 'Image Missing',
            message: 'No image data found for upload.',
          );
          return;
        }
        bytes = _webImageBytes;
      } else {
        if (_pickedImage == null && widget.book['image'] == null) {
          showWarningSnackBar(
            context,
            title: 'Image Missing',
            message: 'No image data found for upload.',
          );
          return;
        }
        bytes = _pickedImage != null ? await _pickedImage!.readAsBytes() : null;
      }

      final base64Image = bytes != null
          ? base64Encode(bytes) // Encode to base64 before sending
          : widget.book['image'];

      final bookId = int.tryParse(_bookIdController.text) ?? 0;

      final bookData = {
        'book_id': bookId,
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'category': _selectedCategory,
        'isbn': _isbnController.text.trim(),
        'library_section': _sectionController.text.trim(),
        'shelf_location': _shelfLocationController.text.trim(),
        'total_copies': int.tryParse(_totalCopiesController.text) ?? 0,
        //'available_copies': int.tryParse(_totalCopiesController.text) ?? 0,
        'book_condition': _selectedCondition,
        'picture': base64Image,
        'year_published': int.tryParse(_yearController.text) ?? 0,
        'version': int.tryParse(_versionController.text) ?? 1,
        'description': _descriptionController.text.trim(),
      };

      try {
        final dio = Dio();
        final response = await dio.put(
          '${ApiConfig.baseUrl}/admin/edit-book/$bookId',
          data: jsonEncode(bookData),
          options: Options(headers: {'Content-Type': 'application/json'}),
        );

        if (response.statusCode == 200 && response.data['retCode'] == '200') {
          showSuccessSnackBar(
            context,
            title: 'Success',
            message: 'Book updated successfully.',
          );
          Navigator.pop(context);
        } else {
          showErrorSnackBar(
            context,
            title: 'Failed',
            message: response.data['message'] ?? 'Failed to update book.',
          );
        }
      } catch (e) {
        print('Error during book update: $e');
        showErrorSnackBar(
          context,
          title: 'Error',
          message: 'Error updating book. Please try again.',
        );
      }
    }
  }

  Widget _getImageWidget() {
    if (kIsWeb && _webImageBytes != null) {
      return Image.memory(
        _webImageBytes!,
        fit: BoxFit
            .cover, // Image will cover the container with potential cropping
      );
    } else if (!kIsWeb && _pickedImage != null) {
      return Image.file(
        _pickedImage!,
        fit: BoxFit
            .cover, // Image will cover the container with potential cropping
      );
    }

    // Check for 'image' instead of 'picture'
    if (widget.book['image'] != null) {
      String base64Image = widget.book['image'];

      // Check for valid base64 characters
      if (base64Image.contains(RegExp(r'[^A-Za-z0-9+/=]'))) {
        print("Invalid base64 string detected.");
      }

      // Clean the base64 string if necessary
      if (base64Image.startsWith('data:image')) {
        base64Image = base64Image.split(',').last;
      }

      try {
        return Image.memory(
          base64Decode(base64Image), // Decode base64 image data
          fit: BoxFit
              .cover, // Image will cover the container with potential cropping
        );
      } catch (e) {
        print("Base64 decoding error: $e");
      }
    }

    return const Center(
      child: Icon(Icons.image, size: 100, color: Colors.grey),
    );
  }

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
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLeftColumn(),
                            const SizedBox(width: 32),
                            _buildRightColumn(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                'Edit Book',
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

  Widget _buildLeftColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap:
                _pickImage, // Call the _pickImage function here to allow uploading a new image
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.shade300), // Border styling
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Column(
                children: [
                  const Text(
                    'Upload Image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Display the picked image if available or the icon otherwise
                  _pickedImage != null || _webImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 160, // Fixed height for the image container
                            //width: double.infinity,
                            child:
                                _getImageWidget(), // Display the image using the _getImageWidget method
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
          _buildCategoryDropdown(),
          if (_selectedCategory == 'Others') ...[
            const SizedBox(height: 16),
            _buildCustomCategoryField(),
          ],
          const SizedBox(height: 16),
          _buildConditionDropdown(),
          const SizedBox(height: 16),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      items: _categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Category',
        floatingLabelStyle: const TextStyle(
          color: AdminColor.secondaryBackgroundColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AdminColor.secondaryBackgroundColor),
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
          if (value != 'Others') {
            _customCategoryController.clear();
          }
        });
      },
      validator: (value) => value == null ? 'Category is required' : null,
    );
  }

  Widget _buildCustomCategoryField() {
    return TextFormField(
      controller: _customCategoryController,
      decoration: InputDecoration(
        labelText: 'Enter Custom Category',
        floatingLabelStyle: const TextStyle(
          color: AdminColor.secondaryBackgroundColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AdminColor.secondaryBackgroundColor),
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (_selectedCategory == 'Others' &&
            (value == null || value.trim().isEmpty)) {
          return 'Please enter a custom category';
        }
        return null;
      },
    );
  }

  Widget _buildConditionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCondition,
      items: conditions
          .map((cond) => DropdownMenuItem(value: cond, child: Text(cond)))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Book Condition',
        floatingLabelStyle: const TextStyle(
          color: AdminColor.secondaryBackgroundColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AdminColor.secondaryBackgroundColor),
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) => setState(() => _selectedCondition = value),
      validator: (value) => value == null ? 'Condition is required' : null,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 8,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Write here...',
        floatingLabelStyle: const TextStyle(
          color: AdminColor.secondaryBackgroundColor,
        ),
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

  Widget _buildRightColumn() {
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
            CustomTextFormField(
                controller: _bookIdController,
                label: 'Book ID',
                inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            CustomTextFormField(
              controller: _titleController,
              label: 'Title',
            ),
            CustomTextFormField(
              controller: _authorController,
              label: 'Author',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                      controller: _yearController,
                      label: 'Year of Publication',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Version',
                    controller: _versionController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
            CustomTextFormField(
              label: 'ISBN',
              controller: _isbnController,
              inputFormatters: [ISBNInputFormatter()],
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                      controller: _totalCopiesController,
                      label: 'Total Copies',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    controller: _sectionController,
                    label: 'Section',
                  ),
                ),
              ],
            ),
            CustomTextFormField(
              controller: _shelfLocationController,
              label: 'Shelf Location',
            ),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
          text: 'Clear All',
          onPressed: _clearAll,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        ),
        const SizedBox(width: 12),
        CustomButton(
          text: 'Save',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              showDialog(
                context: context,
                builder: (context) => SaveValidationModal(
                  onCancel: () => Navigator.pop(context),
                  onSave: () {
                    Navigator.pop(context); // Close the modal
                    _saveForm(); // Call the existing save method
                  },
                ),
              );
            }
          },
          backgroundColor: AdminColor.secondaryBackgroundColor,
          textColor: Colors.white,
        ),
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
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
