import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:flutter/services.dart';
import '../components/settings_components.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/base_url.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isEditing = false;
  bool _isLoading = true;
  bool _isUpdating = false;
  final _dio = Dio();

  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _roleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _programController = TextEditingController();
  final _yearLevelController = TextEditingController();

  String _imageUrl = '';

  final List<String> _avatarChoices = [
    'assets/icons/j-rizz.png',
    'assets/icons/boy-icon.png',
    'assets/icons/girl-icon.png',
    'assets/icons/girl-2.png',
    'assets/icons/reading_book.png',
    'assets/icons/student-boy.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final userData = Provider.of<UserData>(context, listen: false);

    setState(() {
      _firstNameController.text = userData.firstName;
      _lastNameController.text = userData.lastName;

      _emailController.text = userData.email;
      _idNumberController.text = userData.userID;
      _roleController.text = 'Admin';
      _phoneController.text = userData.contactNumber;
      _programController.text = userData.program;
      _yearLevelController.text = userData.yearLevel;
      _imageUrl = userData.avatarPath.isNotEmpty
          ? userData.avatarPath
          : _avatarChoices[0];
      _isLoading = false;
    });
  }

  Future<void> _updateAvatar(String avatarPath) async {
    try {
      final userId = context.read<UserData>().userID;
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/stud/add-pic',
        data: {
          'user_id': userId,
          'avatar_path': avatarPath,
        },
      );

      if (response.statusCode == 200 && response.data['RetCode'] == '200') {
        final userData = Provider.of<UserData>(context, listen: false);
        userData.setAvatarPath(avatarPath);
        setState(() {
          _imageUrl = avatarPath;
        });
        showSuccessSnackBar(
          context,
          title: 'Success',
          message: 'Profile picture updated successfully',
        );
        Navigator.pop(context);
      } else {
        showWarningSnackBar(
          context,
          title: 'Update Failed',
          message:
              response.data['Message'] ?? 'Failed to update profile picture',
        );
      }
    } catch (e) {
      showErrorSnackBar(
        context,
        title: 'Error',
        message: 'Failed to update profile picture: ${e.toString()}',
      );
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose Your Avatar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            5, // Changed from 3 to 4 for tighter grid
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _avatarChoices.length,
                      itemBuilder: (context, index) {
                        final avatarPath = _avatarChoices[index];
                        return GestureDetector(
                          onTap: () => _updateAvatar(avatarPath),
                          child: CircleAvatar(
                            radius: 28, // Reduced from 40 to 28
                            backgroundImage: AssetImage(avatarPath),
                            backgroundColor: Colors.grey[200],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    try {
      final userId = context.read<UserData>().userID;

      // Create temporary data structure
      final Map<String, dynamic> updateData = {
        'user_id':
            _idNumberController.text.trim(), // Use the new ID from the field
        'email': _emailController.text.trim(), // Include email in the update
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'contact_number': _phoneController.text.trim(),
        'program': _programController.text.trim(),
        'year_level': _yearLevelController.text.trim(),
      };

      print('Sending update data: $updateData'); // Debug print

      final response = await _dio.put(
        '${ApiConfig.baseUrl}/stud/edit',
        data: updateData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response received: ${response.data}'); // Debug print

      if (response.statusCode == 200) {
        if (response.data['RetCode'] == '200') {
          final userData = Provider.of<UserData>(context, listen: false);
          final updatedData = response.data['Data'];

          userData.updateUser(
            firstName: updatedData['first_name'],
            lastName: updatedData['last_name'],
            middleName: updatedData['middle_name'] ?? '',
            suffix: updatedData['suffix'] ?? '',
            contactNumber: updatedData['contact_number'],
            program: updatedData['program'],
            yearLevel: updatedData['year_level'],
          );

          // Update the user ID and email in the provider
          userData.setUserData(
            userID: updatedData['user_id'],
            userType: updatedData['user_type'],
            lastName: updatedData['last_name'],
            firstName: updatedData['first_name'],
            middleName: updatedData['middle_name'] ?? '',
            suffix: updatedData['suffix'] ?? '',
            email: updatedData['email'],
            program: updatedData['program'],
            yearLevel: updatedData['year_level'],
            contactNumber: updatedData['contact_number'],
            avatarPath: updatedData['avatar_path'],
          );

          setState(() {
            _isEditing = false;
          });

          showSuccessSnackBar(
            context,
            title: 'Success!',
            message:
                response.data['Message'] ?? 'Profile updated successfully.',
          );
        } else {
          showWarningSnackBar(
            context,
            title: 'Update Failed',
            message: response.data['Message'] ?? 'Failed to update profile',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Server returned status code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      print('DioError response: ${e.response?.data}');

      String errorMessage = 'Failed to update profile';
      if (e.response?.data != null && e.response?.data['Message'] != null) {
        errorMessage = e.response?.data['Message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      showErrorSnackBar(
        context,
        title: 'Error',
        message: errorMessage,
      );
    } catch (e) {
      print('General error: $e');
      showErrorSnackBar(
        context,
        title: 'Error',
        message: 'An unexpected error occurred: $e',
      );
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SettingsCard(
      child: SizedBox(
        height: 420,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LEFT
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(_imageUrl),
                          backgroundColor: Colors.grey[200],
                        ),
                        if (_isEditing)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  AdminColor.secondaryBackgroundColor,
                              child: IconButton(
                                icon: const Icon(Icons.edit,
                                    size: 18, color: Colors.white),
                                onPressed: _showAvatarPicker,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${_firstNameController.text} ${_lastNameController.text}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(_roleController.text),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _isUpdating
                          ? null
                          : (_isEditing ? _saveProfile : _toggleEdit),
                      icon:
                          Icon(_isEditing ? Icons.save : Icons.edit, size: 18),
                      label: Text(_isUpdating
                          ? "Saving..."
                          : (_isEditing ? "Save" : "Edit")),
                      style: FilledButton.styleFrom(
                        backgroundColor: AdminColor.secondaryBackgroundColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // RIGHT
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Personal Information",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                  label: "First Name",
                                  controller: _firstNameController),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildField(
                                  label: "Last Name",
                                  controller: _lastNameController),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                  label: "Email Address",
                                  controller: _emailController,
                                  validator: _validateEmail),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildField(
                                  label: "ID Number",
                                  controller: _idNumberController,
                                  validator: _validateStudentId),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ProfileField(
                                  label: "Role", value: _roleController.text),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildField(
                                label: "Phone Number",
                                controller: _phoneController,
                                validator: _validatePhone,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return _isEditing
        ? TextFormField(
            controller: controller,
            enabled:
                _isEditing, // Remove the condition that disabled ID and email fields
            decoration: InputDecoration(
              labelText: label,
              labelStyle:
                  const TextStyle(color: AdminColor.secondaryBackgroundColor),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AdminColor.secondaryBackgroundColor, width: 1.0),
              ),
            ),
            validator: validator ?? _defaultValidator,
            inputFormatters: [
              if (controller == _idNumberController ||
                  controller == _phoneController)
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            ],
          )
        : ProfileField(label: label, value: controller.text);
  }

  String? _defaultValidator(String? value) =>
      (value == null || value.isEmpty) ? "Required" : null;

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Only numbers are allowed';
    if (!RegExp(r'^(09\d{9}|\+639\d{9})$').hasMatch(value)) {
      return 'Enter a valid Philippine phone number (e.g., 09123456789)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
      return 'Enter a valid Gmail address';
    }
    return null;
  }

  String? _validateStudentId(String? value) {
    if (value == null || value.isEmpty) return 'ID is required';
    if (!RegExp(r'^[0-9]+(-[0-9]+)*$').hasMatch(value)) {
      return 'Use only numbers and dashes';
    }
    return null;
  }
}
