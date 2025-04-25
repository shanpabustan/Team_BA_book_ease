import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';

class BookFormController {
  // Image
  File? pickedImage;
  Uint8List? _webImageBytes;

  Uint8List? get webImageBytes => _webImageBytes;


  // Form Fields
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bookIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController versionController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController totalCopiesController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController shelfLocationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController customCategoryController =
      TextEditingController();

  String? selectedCategory;
  String? selectedCondition;

void pickImage(BuildContext context, StateSetter setState) async {
  if (!kIsWeb) {
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      showWarningSnackBar(
        context,
        title: 'Permission Denied',
        message: 'Photo permission is not granted. Please enable it to proceed.',
      );
      return;
    }
  }

  final result = await FilePicker.platform.pickFiles(type: FileType.image);

  if (result != null && result.files.single.path != null) {
    setState(() {
      if (kIsWeb) {
        _webImageBytes = result.files.single.bytes;
        pickedImage = File(''); // Dummy file
      } else {
        pickedImage = File(result.files.single.path!);
      }
    });
  } else {
    showWarningSnackBar(
      context,
      title: 'Image Not Selected',
      message: 'Please select an image to proceed.',
    );
  }
}

  void clearAll(VoidCallback onClearState) {
    formKey.currentState?.reset();
    bookIdController.clear();
    titleController.clear();
    authorController.clear();
    yearController.clear();
    versionController.clear();
    isbnController.clear();
    totalCopiesController.clear();
    sectionController.clear();
    shelfLocationController.clear();
    descriptionController.clear();
    customCategoryController.clear();
    pickedImage = null;
    selectedCategory = null;
    selectedCondition = null;
    onClearState(); // Notify state update
  }
}
