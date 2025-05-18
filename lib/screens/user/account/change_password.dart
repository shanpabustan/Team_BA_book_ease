import 'package:book_ease/screens/user/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/base_url.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscureCurrentPassword = true;
  bool _isObscureNewPassword = true;
  bool _isObscureConfirmPassword = true;
  bool _isLoading = false;
  final _dio = Dio();

  bool get _isPasswordValid {
    return _formKey.currentState?.validate() ?? false;
  }

  Future<void> _changePassword() async {
    if (!_isPasswordValid) return;

    setState(() => _isLoading = true);

    try {
      final userId = context.read<UserData>().userID;
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/change-password',
        data: {
          'user_id': userId,
          'current_password': _currentPasswordController.text,
          'new_password': _newPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['retCode'] == '200') {
          showSuccessSnackBar(
            context,
            title: 'Success!',
            message: 'Password updated successfully',
          );
          Navigator.pop(context, {'success': true});
        } else {
          showWarningSnackBar(
            context,
            title: 'Update Failed',
            message: response.data['message'] ?? 'Failed to update password',
          );
        }
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'An error occurred';
      if (e.response?.statusCode == 401) {
        showWarningSnackBar(
          context,
          title: 'Authentication Error',
          message: errorMessage,
        );
      } else if (e.response?.statusCode == 404) {
        showWarningSnackBar(
          context,
          title: 'User Not Found',
          message: errorMessage,
        );
      } else {
        showErrorSnackBar(
          context,
          title: 'Error',
          message: errorMessage,
        );
      }
    } catch (e) {
      showErrorSnackBar(
        context,
        title: 'Error',
        message: 'An unexpected error occurred',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Image.asset(
                    'assets/icons/change_password.png',
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.5,
                  ),
                  SizedBox(height: screenHeight * 0.0),
                  Text(
                    'Change Password',
                    style: AppTextStyles.appBarTitle.copyWith(
                      fontSize: screenWidth * 0.05,
                      color: AdminColor.secondaryBackgroundColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Ensure your account is secure by using a strong and unique password.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Current Password',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: _isObscureCurrentPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AdminColor.secondaryBackgroundColor,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AdminColor.secondaryBackgroundColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureCurrentPassword =
                                !_isObscureCurrentPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'New Password',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _isObscureNewPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AdminColor.secondaryBackgroundColor,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AdminColor.secondaryBackgroundColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureNewPassword = !_isObscureNewPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Confirm Password',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _isObscureConfirmPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AdminColor.secondaryBackgroundColor,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AdminColor.secondaryBackgroundColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureConfirmPassword =
                                !_isObscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColor.secondaryBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
