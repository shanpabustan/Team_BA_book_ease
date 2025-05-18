import 'dart:convert';
import 'dart:io';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/admin/managebook/reusable_form.dart';
import 'package:book_ease/widgets/admin_buttons_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AddBookForm extends StatefulWidget {
  const AddBookForm({Key? key}) : super(key: key);

  @override
  State<AddBookForm> createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _bookIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _versionController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _totalCopiesController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _shelfLocationController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  File? _pickedImage;
  Uint8List? _webImageBytes;

  final List<String> _baseCategories = [
    'Information System',
    'Computer Science',
    'Engineering',
    'Mathematics',
    'Fiction',
    'Non-Fiction',
    'Textbooks',
    'Reference Materials',
    "Children's Books",
    'Young Adult (YA)',
    'Science & Technology',
    'History & Social Studies',
    'Biographies',
    'Comics & Graphic Novels',
    'Others',
  ];

  List<String> _categories = [];
  final List<String> conditions = ['New', 'Used'];

  @override
  void initState() {
    super.initState();
    _categories = List.from(_baseCategories);
  }

  // Method to pick an image
  void _pickImage() async {
    // Check permissions only if not on web
    if (!kIsWeb) {
      var status = await Permission.photos.request();
      if (!status.isGranted) {
        if (mounted) {
          showWarningSnackBar(
            context,
            title: 'Permission Denied',
            message:
                'Photo permission is not granted. Please allow access to your photos.',
          );
        }
        return;
      }
    }

    // Pick an image using FilePicker
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        if (kIsWeb) {
          _webImageBytes = result.files.single.bytes;
          _pickedImage = File(''); // Dummy to indicate an image is picked
        } else {
          _pickedImage = File(result.files.single.path!);
        }
      });
    } else {
      if (mounted) {
        showWarningSnackBar(
          context,
          title: 'No Image Selected',
          message: 'Please select an image to upload.',
        );
      }
    }
  }

  // Clear all form fields
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
    setState(() {
      _pickedImage = null;
      _webImageBytes = null;
      _selectedCategory = null;
      _selectedCondition = null;
    });
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      // Check if image is null
      if (_pickedImage == null && _webImageBytes == null) {
        showWarningSnackBar(
          context,
          title: 'Image Required',
          message: 'Please upload an image to proceed.',
        );
        return;
      }

      // Handle custom category if "Others" was selected
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

      // Ensure image is available before proceeding
      Uint8List bytes;
      try {
        if (kIsWeb) {
          if (_webImageBytes == null) {
            showErrorSnackBar(
              context,
              title: 'Image Missing',
              message: 'No image data found for upload.',
            );
            return;
          }
          bytes = _webImageBytes!;
        } else {
          if (_pickedImage == null) {
            showErrorSnackBar(
              context,
              title: 'Image Missing',
              message: 'No image data found for upload.',
            );
            return;
          }
          bytes = await _pickedImage!.readAsBytes();
        }

        final base64Image = base64Encode(bytes);

        final bookData = {
          'book_id': int.tryParse(_bookIdController.text) ?? 0,
          'title': _titleController.text.trim(),
          'author': _authorController.text.trim(),
          'category': _selectedCategory,
          'isbn': _isbnController.text.trim(),
          'library_section': _sectionController.text.trim(),
          'shelf_location': _shelfLocationController.text.trim(),
          'total_copies': int.tryParse(_totalCopiesController.text) ?? 0,
          'available_copies': int.tryParse(_totalCopiesController.text) ?? 0,
          'book_condition': _selectedCondition,
          'picture': base64Image,
          'year_published': int.tryParse(_yearController.text) ?? 0,
          'version': int.tryParse(_versionController.text) ?? 1,
          'description': _descriptionController.text.trim(),
        };

        final dio = Dio();
        dio.options.connectTimeout =
            const Duration(seconds: 30); // 30 seconds timeout
        dio.options.receiveTimeout = const Duration(seconds: 15);
        dio.options.sendTimeout = const Duration(seconds: 15);

        try {
          final response = await dio.post(
            '${ApiConfig.baseUrl}/admin/add-book',
            data: bookData,
            options: Options(
              headers: {'Content-Type': 'application/json'},
              validateStatus: (status) => true,
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
            ),
          );

          print('Response status: ${response.statusCode}');
          print('Response data: ${response.data}');

          if (response.statusCode == 200 && response.data['retCode'] == '200') {
            showSuccessSnackBar(
              context,
              title: 'Success',
              message: 'Book added successfully.',
            );
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) Navigator.pop(context);
          } else {
            String errorMessage = 'Failed to add book.';
            if (response.data != null && response.data['message'] != null) {
              errorMessage = response.data['message'];
            } else if (response.statusCode != 200) {
              errorMessage = 'Server error: ${response.statusCode}';
            }
            showErrorSnackBar(
              context,
              title: 'Failed',
              message: errorMessage,
            );
          }
        } on DioException catch (e) {
          print('DioException type: ${e.type}');
          print('DioException message: ${e.message}');
          print('DioException response: ${e.response}');

          String errorMessage;
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              errorMessage = 'Request timed out. Please try again.';
              break;
            case DioExceptionType.connectionError:
              errorMessage =
                  'Could not connect to the server. Please check if the server is running.';
              break;
            case DioExceptionType.badResponse:
              errorMessage =
                  'Server error: ${e.response?.statusCode ?? "Unknown"}\n${e.response?.data?['message'] ?? ""}';
              break;
            default:
              errorMessage = 'An unexpected error occurred: ${e.message}';
          }
          showErrorSnackBar(
            context,
            title: 'Connection Error',
            message: errorMessage,
          );
        } catch (e) {
          print('General error: $e');
          showErrorSnackBar(
            context,
            title: 'Error',
            message: 'Failed to process request: $e',
          );
        }
      } catch (e) {
        showErrorSnackBar(
          context,
          title: 'Error',
          message: 'Failed to process image or submit book. Please try again.',
        );
      }
    }
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
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5)),
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
                ),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text('Upload Image'),
                                          const SizedBox(height: 12),
                                          _pickedImage != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: kIsWeb
                                                      ? (_webImageBytes != null
                                                          ? Image.memory(
                                                              _webImageBytes!,
                                                              height: 160,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : const Icon(
                                                              Icons.image,
                                                              size: 100,
                                                              color:
                                                                  Colors.grey))
                                                      : Image.file(
                                                          _pickedImage!,
                                                          height: 160,
                                                          fit: BoxFit.cover,
                                                        ),
                                                )
                                              : const Icon(Icons.image,
                                                  size: 100,
                                                  color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    value: _selectedCategory,
                                    items: _categories
                                        .map((cat) => DropdownMenuItem(
                                              value: cat,
                                              child: Text(cat),
                                            ))
                                        .toList(),
                                    decoration: InputDecoration(
                                      labelText: 'Category',
                                      floatingLabelStyle: const TextStyle(
                                        color:
                                            AdminColor.secondaryBackgroundColor,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AdminColor
                                              .secondaryBackgroundColor,
                                        ),
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
                                    validator: (value) => value == null
                                        ? 'Category is required'
                                        : null,
                                  ),
                                  if (_selectedCategory == 'Others') ...[
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _customCategoryController,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Custom Category',
                                        floatingLabelStyle: const TextStyle(
                                          color: AdminColor
                                              .secondaryBackgroundColor,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AdminColor
                                                .secondaryBackgroundColor,
                                          ),
                                        ),
                                        border: const OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (_selectedCategory == 'Others' &&
                                            (value == null ||
                                                value.trim().isEmpty)) {
                                          return 'Please enter a custom category';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    value: _selectedCondition,
                                    items: conditions
                                        .map((cond) => DropdownMenuItem(
                                              value: cond,
                                              child: Text(cond),
                                            ))
                                        .toList(),
                                    decoration: InputDecoration(
                                      labelText: 'Book Condition',
                                      floatingLabelStyle: const TextStyle(
                                        color:
                                            AdminColor.secondaryBackgroundColor,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AdminColor
                                              .secondaryBackgroundColor,
                                        ),
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                    onChanged: (value) => setState(
                                        () => _selectedCondition = value),
                                    validator: (value) => value == null
                                        ? 'Condition is required'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _descriptionController,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      hintText: 'Write here...',
                                      floatingLabelStyle: const TextStyle(
                                        color:
                                            AdminColor.secondaryBackgroundColor,
                                      ),
                                      alignLabelWithHint: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 43,
                                        horizontal: 16,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AdminColor
                                              .secondaryBackgroundColor,
                                        ),
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Description is required'
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            // Right Column
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
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
                                    BookTextField(
                                      label: 'Book ID',
                                      controller: _bookIdController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                    BookTextField(
                                      label: 'Title',
                                      controller: _titleController,
                                    ),
                                    BookTextField(
                                      label: 'Author',
                                      controller: _authorController,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: BookTextField(
                                            label: 'Year Published',
                                            controller: _yearController,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: BookTextField(
                                            label: 'Version',
                                            controller: _versionController,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d{0,2}')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    BookTextField(
                                      label: 'ISBN',
                                      controller: _isbnController,
                                      inputFormatters: [ISBNInputFormatter()],
                                      keyboardType: TextInputType.number,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: BookTextField(
                                            label: 'Total Copies',
                                            controller: _totalCopiesController,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: BookTextField(
                                            label: 'Library Section',
                                            controller: _sectionController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    BookTextField(
                                      label: 'Shelf Location',
                                      controller: _shelfLocationController,
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
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
                                          onPressed: _saveForm,
                                          backgroundColor: AdminColor
                                              .secondaryBackgroundColor,
                                          textColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
}

class BookTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const BookTextField({
    required this.label,
    required this.controller,
    this.inputFormatters,
    this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
