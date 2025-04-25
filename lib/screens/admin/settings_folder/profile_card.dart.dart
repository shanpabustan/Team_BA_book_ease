import 'package:book_ease/screens/admin/mock_data/admin_mock_data.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:flutter/services.dart';
import '../components/settings_components.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late UserProfile _profile;
  bool _isEditing = false;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _roleController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserProfile.fetchDummy();
    setState(() {
      _profile = profile;
      _isLoading = false;

      _firstNameController.text = profile.firstName;
      _lastNameController.text = profile.lastName;
      _emailController.text = profile.email;
      _idNumberController.text = profile.idNumber;
      _roleController.text = profile.role; // This will remain unchanged
      _phoneController.text = profile.phoneNumber;
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _profile = UserProfile(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          idNumber: _idNumberController.text,
          role: _profile.role, // Role remains unchanged
          phoneNumber: _phoneController.text,
          imageUrl: _profile.imageUrl,
        );
        _isEditing = false;
      });
      // Somewhere in your code after a successful profile update
      showSuccessSnackBar(
        context,
        title: 'Success!',
        message: 'Profile updated successfully.',
      );
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
              // LEFT SIDE
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_profile.imageUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${_profile.firstName} ${_profile.lastName}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(_profile.role),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _isEditing ? _saveProfile : _toggleEdit,
                      icon:
                          Icon(_isEditing ? Icons.save : Icons.edit, size: 18),
                      label: Text(_isEditing ? "Save" : "Edit"),
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

              // RIGHT SIDE
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
                            // Use ProfileField for Role (Read-Only)
                            Expanded(
                              child: ProfileField(
                                label: "Role",
                                value: _profile.role,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildField(
                                  label: "Phone Number",
                                  controller: _phoneController,
                                  validator: _validatePhone),
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
    bool readOnly = false,
  }) {
    return _isEditing
        ? TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                color: AdminColor.secondaryBackgroundColor,
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AdminColor
                      .secondaryBackgroundColor, // Set focus border color
                  width: 1.0, // Set border width to 1
                ),
              ),
            ),
            validator: validator ?? _defaultValidator,
            readOnly: readOnly,
            inputFormatters: [
              if (controller == _idNumberController ||
                  controller == _phoneController)
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9-]')), // Allow only numbers and dash
            ],
          )
        : ProfileField(label: label, value: controller.text);
  }

  String? _defaultValidator(String? value) {
    return (value == null || value.isEmpty) ? "Required" : null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    if (!RegExp(r'^(09\d{9}|\+639\d{9})$').hasMatch(value)) {
      return 'Enter a valid Philippine phone number (e.g., 09123456789 or +639123456789)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // This regex matches only the format username@gmail.com
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
      return 'Enter a valid email address with the domain "@gmail.com"';
    }
    return null;
  }

  String? _validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID is required';
    }
    final RegExp studentIdRegex = RegExp(r'^[0-9]+(-[0-9]+)*$');
    if (!studentIdRegex.hasMatch(value)) {
      return 'ID must contain only numbers and dashes, and not start or end with a dash';
    }
    return null;
  }
}
