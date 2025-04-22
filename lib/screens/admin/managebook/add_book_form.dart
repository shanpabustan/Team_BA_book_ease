import 'dart:convert';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/components/book_form_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:book_ease/screens/admin/components/book_form_content.dart';

class AddBookForm extends StatefulWidget {
  const AddBookForm({super.key});

  @override
  State<AddBookForm> createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final BookFormController _controller = BookFormController();
  final List<String> _baseCategories = [
    'Information System',
    'Computer Science',
    'Engineering',
    'Mathematics',
    'Others',
  ];
  List<String> _categories = [];
  Uint8List? _webImageBytes;

  final List<String> conditions = ['New', 'Good', 'Fair', 'Poor'];

  @override
  void initState() {
    super.initState();
    _categories = List.from(_baseCategories);
  }

  void _saveForm() async {
    if (_controller.formKey.currentState!.validate()) {
      if (_controller.pickedImage == null) {
        showWarningSnackBar(
          context,
          title: 'Image Upload Required',
          message: 'Please upload an image to proceed.',
        );
        return;
      }

      if (_controller.selectedCategory == 'Others') {
        final customCategory = _controller.customCategoryController.text.trim();
        if (customCategory.isEmpty) {
          showWarningSnackBar(
            context,
            title: 'Custom Category Required',
            message: 'Please enter a custom category to proceed.',
          );
          return;
        }

        if (!_categories.contains(customCategory)) {
          setState(() {
            _categories.insert(_categories.length - 1, customCategory);
            _controller.selectedCategory = customCategory;
          });
        }
      }

      try {
        final bytes = kIsWeb
            ? _webImageBytes!
            : await _controller.pickedImage!.readAsBytes();
        final base64Image = base64Encode(bytes);

        final bookData = {
          'book_id': int.parse(_controller.bookIdController.text),
          'title': _controller.titleController.text,
          'author': _controller.authorController.text,
          'category': _controller.selectedCategory,
          'isbn': _controller.isbnController.text,
          'library_section': _controller.sectionController.text,
          'shelf_location': _controller.shelfLocationController.text,
          'total_copies': int.parse(_controller.totalCopiesController.text),
          'available_copies': int.parse(_controller.totalCopiesController.text),
          'book_condition': _controller.selectedCondition,
          'picture': base64Image,
          'year_published': int.parse(_controller.yearController.text),
          'version': int.parse(_controller.versionController.text),
          'description': _controller.descriptionController.text,
        };

        final dio = Dio();
        final response = await dio.post(
          '${ApiConfig.baseUrl}/admin/add-book',
          data: bookData,
          options: Options(headers: {'Content-Type': 'application/json'}),
        );

        if (response.statusCode == 200 && response.data['retCode'] == '200') {
          showSuccessSnackBar(
            context,
            title: 'Book Added Successfully!',
            message: 'The book has been added to the system.',
          );
          Navigator.pop(context);
        } else {
          showErrorSnackBar(
            context,
            title: 'Error Adding Book',
            message: 'Failed to add book: ${response.data['message']}',
          );
        }
      } catch (e) {
        print('Error during book submission: $e');
        showErrorSnackBar(
          context,
          title: 'Error Adding Book',
          message: 'There was an error adding the book. Please try again.',
        );
      }
    }
  }

  // Define the onCategoryChanged function to handle category selection
  void _onCategoryChanged(String? newCategory) {
    setState(() {
      _controller.selectedCategory = newCategory ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AddBookFormContent(
      formKey: _controller.formKey,
      bookIdController: _controller.bookIdController,
      titleController: _controller.titleController,
      authorController: _controller.authorController,
      yearController: _controller.yearController,
      versionController: _controller.versionController,
      isbnController: _controller.isbnController,
      totalCopiesController: _controller.totalCopiesController,
      sectionController: _controller.sectionController,
      shelfLocationController: _controller.shelfLocationController,
      descriptionController: _controller.descriptionController,
      customCategoryController: _controller.customCategoryController,
      selectedCategory: _controller.selectedCategory,
      selectedCondition: _controller.selectedCondition,
      categories: _categories,
      conditions: conditions,
      pickedImage: _controller.pickedImage,
      onPickImage: () => _controller.pickImage(context, () => setState(() {})),
      onClear: () => _controller.clearAll(() => setState(() {})),
      onSave: _saveForm,
      onCategoryChanged:
          _onCategoryChanged, // Add the onCategoryChanged parameter
    );
  }
}
