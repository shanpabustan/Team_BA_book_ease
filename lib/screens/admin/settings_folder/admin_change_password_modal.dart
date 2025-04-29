import 'package:book_ease/widgets/admin_password_criteria_widget.dart';
import 'package:book_ease/widgets/admin_password_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/widgets/admin_small_button_widget.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

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
                  text: 'Apply Changes',
                  onPressed: _isPasswordValid
                      ? () {
                          if (widget.onSubmit != null) {
                            widget.onSubmit!(
                              _currentPasswordController.text,
                              _newPasswordController.text,
                            );
                          }
                          Navigator.pop(context, {
                            'success': true,
                          });
                        }
                      : () {},
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
