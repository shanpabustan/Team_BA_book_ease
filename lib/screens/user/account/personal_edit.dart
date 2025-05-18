import 'package:book_ease/screens/user/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class PersonalInfoEditScreen extends StatefulWidget {
  const PersonalInfoEditScreen({super.key});

  @override
  _PersonalInfoEditScreenState createState() => _PersonalInfoEditScreenState();
}

class _PersonalInfoEditScreenState extends State<PersonalInfoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();
  // Controllers
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  // Dropdown values
  String? _selectedCourse;
  String? _selectedYearLevel;

  final List<String> _courses = [
    'BS Computer Science',
    'BS Information Technology',
    'BS Business Administration',
    'BS Engineering',
    'BS Education',
  ];
  final List<String> _yearLevels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year'
  ];

  @override
  void initState() {
    super.initState();
    final userData = Provider.of<UserData>(context, listen: false);
    _lastNameController.text = userData.lastName;
    _firstNameController.text = userData.firstName;
    _middleNameController.text = userData.middleName;
    _suffixController.text = userData.suffix;
    _emailController.text = userData.email;
    _phoneController.text = userData.contactNumber;
    _studentIdController.text = userData.userID;
    _selectedCourse = userData.program;
    _selectedYearLevel = userData.yearLevel;
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _suffixController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _dio.put(
          '${ApiConfig.baseUrl}/stud/edit',
          data: {
            "user_id": _studentIdController.text,
            "first_name": _firstNameController.text,
            "last_name": _lastNameController.text,
            "middle_name": _middleNameController.text,
            "suffix":
                _suffixController.text.isEmpty ? "" : _suffixController.text,
            "contact_number": _phoneController.text,
            "program": _selectedCourse,
            "year_level": _selectedYearLevel,
          },
        );

        if (response.statusCode == 200) {
          Provider.of<UserData>(context, listen: false).updateUser(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            middleName: _middleNameController.text,
            suffix: _suffixController.text,
            contactNumber: _phoneController.text,
            program: _selectedCourse ?? '',
            yearLevel: _selectedYearLevel ?? '',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User info updated successfully!")),
          );
          Navigator.pop(context);
        } else {
          throw Exception("Failed to update user");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Edit Personal Information",
          style: AppTextStyles.appBarTitle.copyWith(
            color: Colors.white,
            fontFamily: 'Poppins', // Optional if you want to enforce Poppins
          ),
        ),
        backgroundColor: AdminColor.secondaryBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  // Non-editable fields
                  _buildTextField("Last Name", _lastNameController),
                  const SizedBox(height: 10),
                  _buildTextField("First Name", _firstNameController),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField(
                              "Middle Name", _middleNameController)),
                      const SizedBox(width: 10),
                      SizedBox(
                          width: 80,
                          child: _buildTextField(
                            "Suffix",
                            _suffixController,
                            validator: (value) => _validateField(
                                value, "Suffix",
                                required: false),
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Editable fields
                  _buildTextField(
                    "Phone Number",
                    _phoneController,
                    validator: _validatePhone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 10),
                  _buildDisabledField("Email", _emailController),
                  const SizedBox(height: 10),
                  _buildDisabledField("Student ID", _studentIdController),
                  const SizedBox(height: 15),

                  // Dropdowns
                  _buildDropdownField(
                    "Course",
                    _selectedCourse,
                    _courses,
                    (value) => setState(() => _selectedCourse = value),
                  ),
                  const SizedBox(height: 15),
                  _buildDropdownField(
                    "Year Level",
                    _selectedYearLevel,
                    _yearLevels,
                    (value) => setState(() => _selectedYearLevel = value),
                  ),
                  const SizedBox(height: 30),

                  _saveButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Non-editable (Disabled) Fields
  Widget _buildDisabledField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle:
            const TextStyle(color: AdminColor.secondaryBackgroundColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200], // Grey background to indicate disabled
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Editable Text Fields
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ?? (value) => _validateField(value, label),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle:
            const TextStyle(color: AdminColor.secondaryBackgroundColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AdminColor.secondaryBackgroundColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // // Dropdown Fields
  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    items = items.toSet().toList(); // Remove duplicates

    return DropdownButtonFormField<String>(
      value: value,
      validator: (val) => val == null ? '$label is required' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle:
            const TextStyle(color: AdminColor.secondaryBackgroundColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AdminColor.secondaryBackgroundColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      dropdownColor: Colors.white,
    );
  }

  // Save Button
  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminColor.secondaryBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text("Save Changes",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }

  // Field Validation
  String? _validateField(String? value, String fieldName,
      {bool required = true}) {
    if (required && (value == null || value.isEmpty)) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Only numbers are allowed';
    if (!RegExp(r'^(09\d{9}|\+639\d{9})$').hasMatch(value)) {
      return 'Enter a valid PH phone number (e.g., 09123456789)';
    }
    return null;
  }
}
