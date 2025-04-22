import 'package:book_ease/base_url.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/info_snack_bar.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:book_ease/screens/auth/login.dart';
import 'package:dio/dio.dart';

class MultiStepSignUpScreen extends StatefulWidget {
  const MultiStepSignUpScreen({super.key});

  @override
  _MultiStepSignUpScreenState createState() => _MultiStepSignUpScreenState();
}

class _MultiStepSignUpScreenState extends State<MultiStepSignUpScreen> {
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  int _currentStep = 0; // Track which step we are in

  // Step 1 Controllers
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Step 2 Controllers
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Dropdown values
  String? _selectedCourse;
  String? _selectedYearLevel;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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

  // Validation functions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
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
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Enter a valid email address (e.g., user@example.com)';
    }
    return null;
  }

  String? _validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Student ID is required';
    }
    final RegExp studentIdRegex = RegExp(r'^[0-9-]+$');
    if (!studentIdRegex.hasMatch(value)) {
      return 'Only numbers and dashes (-) are allowed';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Validation functions

  // MULTI STEP FEATURES

  void _nextStep() async {
    if (_currentStep == 0 && _formKeyStep1.currentState!.validate()) {
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1 && _formKeyStep2.currentState!.validate()) {
      _registerUser(); // ✅ Call the API when all steps are valid
    }
  }

  void _registerUser() async {
    final Dio dio = Dio();

    // 🔥 Use correct API URL (Replace with your actual IP)
    final String apiUrl = "${ApiConfig.baseUrl}/stud/register";

    try {
      Response response = await dio.post(
        apiUrl,
        data: {
          "last_name": _lastNameController.text,
          "first_name": _firstNameController.text,
          "middle_name": _middleNameController.text,
          "suffix": _suffixController.text,
          "contact_number": _phoneController.text,
          "email": _emailController.text,
          "user_id": _studentIdController.text, // Manually input by the student
          "program": _selectedCourse,
          "year_level": _selectedYearLevel,
          "password": _passwordController.text,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.data["RetCode"] == "201") {
        if (mounted) {
          showSuccessSnackBar(
            context,
            title: 'Registration Successful!',
            message: 'Your account has been created successfully.',
          );

          // Navigate to Login Screen
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      } else {
        if (mounted) {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text(response.data["Message"])));
          showInfoSnackBar(
            context,
            title: 'Information!',
            message: response.data["Message"],
          );
        }
      }
    } catch (e) {
      // Use a logging framework instead of print
      debugPrint("API ERROR: ${e.toString()}");

      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text("Failed to register. Please try again.")));
        showErrorSnackBar(
          context,
          title: 'Registration Failed!',
          message: 'Failed to register. Please try again.',
        );
      }
    }
  }

  // ignore: unused_element
  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _currentStep == 0 ? _buildStep1() : _buildStep2(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginScreen(), // ✅ Navigates to Login Page
                          ),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Step 1 UI
  Widget _buildStep1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          _backButton(),
          Image.asset('assets/images/logo-removebg-preview.png',
              width: 250, height: 250),
          const SizedBox(height: 5),
          const SizedBox(height: 5),
          _buildTextField("Lastname", _lastNameController, _validateName),
          const SizedBox(height: 8),
          _buildTextField("Firstname", _firstNameController, _validateName),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                    "Middlename", _middleNameController, _validateName),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 80,
                child: _buildTextField("Suffix", _suffixController, null),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTextField(
            "Phone Number",
            _phoneController,
            _validatePhone,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 8),
          _buildTextField(
            "Email",
            _emailController,
            _validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          _nextButton('Next'),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // Step 2 UI
  Widget _buildStep2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          _backButton(),
          Image.asset('assets/images/logo-removebg-preview.png',
              width: 250, height: 250),
          const SizedBox(height: 5),
          _buildTextField(
              "Student ID", _studentIdController, _validateStudentId,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9-]+$'))
              ]),
          const SizedBox(height: 15),
          _buildDropdownField("Course", _selectedCourse, _courses,
              (value) => setState(() => _selectedCourse = value)),
          const SizedBox(height: 15),
          _buildDropdownField("Year Level", _selectedYearLevel, _yearLevels,
              (value) => setState(() => _selectedYearLevel = value)),
          const SizedBox(height: 15),
          _buildPasswordField("Password", _passwordController, _obscurePassword,
              () => setState(() => _obscurePassword = !_obscurePassword)),
          const SizedBox(height: 15),
          _buildPasswordField(
              "Confirm Password",
              _confirmPasswordController,
              _obscureConfirmPassword,
              () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
              validator: _validateConfirmPassword),
          const SizedBox(height: 40),
          _nextButton('Sign Up'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _backButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _nextButton(String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nextStep,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.white))),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      String? Function(String?)? validator,
      {TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter>? inputFormatters}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback onToggle, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle:
            const TextStyle(color: Colors.teal), // Floating label turns teal
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.teal, width: 2), // ✅ Teal border when focused
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.teal, // ✅ Teal icon for consistency
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      validator:
          _validateName, // Make sure _validateField is used instead of _validateName
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle:
            const TextStyle(color: Colors.teal), // Floating label turns teal
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.teal, width: 2), // ✅ Teal border when focused
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items
          .map(
              (String item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      dropdownColor: Colors.white, // Background color of the dropdown menu
    );
  }
}
