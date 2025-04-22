import 'dart:io';
import 'package:book_ease/screens/admin/components/book_form_content.dart';
import 'package:book_ease/screens/admin/components/book_form_controller.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:flutter/material.dart';

class EditBookForm extends StatefulWidget {
  final Map<String, dynamic> book;

  const EditBookForm({super.key, required this.book});

  @override
  State<EditBookForm> createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  final BookFormController _controller = BookFormController();
  final List<String> _baseCategories = [
    'Information System',
    'Computer Science',
    'Engineering',
    'Mathematics',
    'Others',
  ];
  late List<String> _categories;
  final List<String> _conditions = ['New', 'Used'];

  @override
  void initState() {
    super.initState();

    _categories = List.from(_baseCategories);

    _controller.bookIdController.text = widget.book['bookId'];
    _controller.titleController.text = widget.book['title'];
    _controller.authorController.text = widget.book['author'];
    _controller.yearController.text = widget.book['year'];
    _controller.versionController.text = widget.book['version'];
    _controller.isbnController.text = widget.book['isbn'];
    _controller.totalCopiesController.text = widget.book['copies'];
    _controller.sectionController.text = widget.book['section'];
    _controller.shelfLocationController.text = widget.book['shelfLocation'];
    _controller.descriptionController.text = widget.book['description'];
    _controller.selectedCategory = widget.book['category'];
    _controller.selectedCondition = widget.book['condition'];

    if (widget.book['image'] != null) {
      _controller.pickedImage = File(widget.book['image']);
    }
  }

  void _saveForm() {
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
        final custom = _controller.customCategoryController.text.trim();
        if (custom.isEmpty) {
          showWarningSnackBar(
            context,
            title: 'Missing Custom Category',
            message: 'Please enter a custom category.',
          );
          return;
        }

        if (!_categories.contains(custom)) {
          setState(() {
            _categories.insert(_categories.length - 1, custom);
            _controller.selectedCategory = custom;
          });
        }
      }

      final bookData = {
        'bookId': _controller.bookIdController.text,
        'title': _controller.titleController.text,
        'author': _controller.authorController.text,
        'year': _controller.yearController.text,
        'version': _controller.versionController.text,
        'isbn': _controller.isbnController.text,
        'copies': _controller.totalCopiesController.text,
        'section': _controller.sectionController.text,
        'shelfLocation': _controller.shelfLocationController.text,
        'category': _controller.selectedCategory,
        'condition': _controller.selectedCondition,
        'description': _controller.descriptionController.text,
        'image': _controller.pickedImage?.path ?? '',
      };

      print("✅ Updated Book Data: $bookData");

      showSuccessSnackBar(
        context,
        title: 'Update Successful!',
        message: 'Book updated successfully.',
      );

      Navigator.pop(context);
    }
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
      conditions: _conditions,
      pickedImage: _controller.pickedImage,
      onPickImage: () => _controller.pickImage(context, () => setState(() {})),
      onClear: () => _controller.clearAll(() => setState(() {})),
      onSave: _saveForm,
      onCategoryChanged: (newCategory) {
        setState(() {
          _controller.selectedCategory = newCategory;
        });
      },
    );
  }
}
