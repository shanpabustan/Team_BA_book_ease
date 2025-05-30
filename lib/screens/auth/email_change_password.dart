import 'package:book_ease/screens/admin/admin_theme.dart';
import 'package:book_ease/screens/auth/login.dart';
import 'package:book_ease/screens/auth/verify_reset_code.dart';
import 'package:book_ease/services/password_reset_service.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/navigator_helper.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(EmailForgotPassword());

class EmailForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot Password',
      home: ForgotPasswordScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> _requestPasswordReset() async {
    if (emailController.text.isEmpty) {
      showWarningSnackBar(
        context,
        title: 'Missing Information',
        message: 'Please enter your email',
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await PasswordResetService.requestPasswordReset(
        emailController.text,
      );

      if (response['retCode'] == '200') {
        showSuccessSnackBar(
          context,
          title: 'Success',
          message: 'Reset code sent to your email',
        );
        fadePush(
          context,
          VerifyResetCodeScreen(email: emailController.text),
        );
      } else {
        showErrorSnackBar(
          context,
          title: 'Error',
          message: response['message'] ?? 'Failed to send reset code',
        );
      }
    } catch (e) {
      showErrorSnackBar(
        context,
        title: 'Unexpected Error',
        message: 'An error occurred: $e',
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/email-send-password.png',
                  height: 150,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Forgot your password?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your email so that we can send you password reset link',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email here...',
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintText: 'e.g. username@gmail.com',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: AdminColor.secondaryBackgroundColor),
                    ),
                    floatingLabelStyle: const TextStyle(
                        color: AdminColor.secondaryBackgroundColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: AdminColor.secondaryBackgroundColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AdminColor.secondaryBackgroundColor,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColor.secondaryBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : _requestPasswordReset,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Send Email',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    fadePush(context, const LogBookEaseApp());
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 18, color: Colors.black54),
                      SizedBox(width: 5),
                      Text(
                        'Back to Login',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
