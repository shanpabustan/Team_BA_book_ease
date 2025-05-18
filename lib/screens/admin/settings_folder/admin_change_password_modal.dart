import 'package:book_ease/widgets/admin_password_criteria_widget.dart';
import 'package:book_ease/widgets/admin_password_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/widgets/admin_small_button_widget.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:dio/dio.dart';
import 'package:book_ease/base_url.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';

class PasswordChangeForm extends StatefulWidget {
  final bool isModal;
  final Function(String, String)? onSubmit;

  const PasswordChangeForm({
    super.key,
    this.isModal = true,
    this.onSubmit,
  });

  @override
  State<PasswordChangeForm> createState() => _PasswordChangeFormState();
}

class _PasswordChangeFormState extends State<PasswordChangeForm> {
  final _formKey = GlobalKey<FormState>();
  final _dio = Dio();
  bool _isLoading = false;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasMinLength = false;

  bool _isPasswordFieldTouched = false;
  bool _isConfirmPasswordTouched = false;

  void _checkPasswordStrength(String value) {
    setState(() {
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasLowercase = value.contains(RegExp(r'[a-z]'));
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasMinLength = value.length >= 8;
    });
  }

  bool get _isPasswordValid =>
      _hasUppercase &&
      _hasLowercase &&
      _hasNumber &&
      _hasMinLength &&
      _newPasswordController.text == _confirmPasswordController.text &&
      _newPasswordController.text != _currentPasswordController.text;

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
      final errorMessage = e.response?.data['message'] ?? e.message ?? 'An error occurred';
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
    return widget.isModal
        ? Scaffold(
            backgroundColor: Colors.black.withOpacity(0.3),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildForm(),
              ),
            ),
          )
        : _buildForm(); // For non-modal use
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            PasswordFieldWidget(
              label: "Current Password",
              controller: _currentPasswordController,
              obscure: _obscureCurrent,
              toggleVisibility: () =>
                  setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            const SizedBox(height: 16),
            PasswordFieldWidget(
              label: "New Password",
              controller: _newPasswordController,
              obscure: _obscureNew,
              toggleVisibility: () =>
                  setState(() => _obscureNew = !_obscureNew),
              onChanged: (value) {
                setState(() => _isPasswordFieldTouched = true);
                _checkPasswordStrength(value);
              },
            ),
            const SizedBox(height: 16),
            PasswordFieldWidget(
              label: "Confirm Password",
              controller: _confirmPasswordController,
              obscure: _obscureConfirm,
              toggleVisibility: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              onChanged: (value) {
                setState(() => _isConfirmPasswordTouched = true);
              },
            ),
            const SizedBox(height: 8),
            if (_isConfirmPasswordTouched &&
                _confirmPasswordController.text != _newPasswordController.text)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Passwords do not match.",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_isPasswordFieldTouched &&
                !(_hasUppercase &&
                    _hasLowercase &&
                    _hasNumber &&
                    _hasMinLength))
              PasswordCriteriaWidget(
                hasUppercase: _hasUppercase,
                hasLowercase: _hasLowercase,
                hasNumber: _hasNumber,
                hasMinLength: _hasMinLength,
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.isModal)
                  CustomSmallButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: Colors.grey.shade300,
                    hoverColor: Colors.grey.shade200,
                  ),
                const SizedBox(width: 12),
                CustomSmallButton(
                  text: _isLoading ? 'Updating...' : 'Apply Changes',
                  onPressed: _isPasswordValid && !_isLoading ? () => _changePassword() : () {},
                  backgroundColor: AdminColor.secondaryBackgroundColor,
                  textColor: Colors.white,
                  borderColor: AdminColor.secondaryBackgroundColor,
                  hoverColor:
                      AdminColor.secondaryBackgroundColor.withOpacity(0.85),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
