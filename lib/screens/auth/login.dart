import 'package:book_ease/screens/auth/email_change_password.dart';
import 'package:book_ease/utils/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/base_url.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:book_ease/utils/error_snack_bar.dart';
import 'package:book_ease/utils/warning_snack_bar.dart';
import 'package:book_ease/screens/user/home/user_dashboard.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:book_ease/provider/user_data.dart';
import 'multisignup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

import 'package:book_ease/widgets/svg_loading_screen.dart'; // <-- import your loading widget here

void main() {
  runApp(const LogBookEaseApp());
}

class LogBookEaseApp extends StatelessWidget {
  const LogBookEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Starting route
      routes: {
        '/': (context) => const LoginScreen(),
        '/userDashboard': (context) =>
            const UserDashApp(), // Your user dashboard widget
        '/adminDashboard': (context) =>
            AdminDashboard(), // Your admin dashboard widget
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // <-- loading flag

  void _loginUser() async {
    final Dio dio = Dio();
    final String apiUrl = "${ApiConfig.baseUrl}/stud/login";

    try {
      Response response = await dio.post(
        apiUrl,
        data: {
          "user_id": _idController.text,
          "password": _passwordController.text,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      final data = response.data;

      if (data["retCode"] == "200") {
        final userData = data["data"];
        String userType = userData["user_type"];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userID', userData["user_id"]);
        await prefs.setString('userType', userType);
        await prefs.setString('current_user_id', userData["user_id"]);

        if (mounted) {
          showSuccessSnackBar(
            context,
            title: 'Login Successful!',
            message: 'You have logged in successfully.',
          );
          // Show loading screen
          setState(() {
            _isLoading = true;
          });
        }

        final userProvider = Provider.of<UserData>(context, listen: false);
        userProvider.setUserData(
          userID: userData["user_id"],
          userType: userData["user_type"],
          lastName: userData["last_name"],
          firstName: userData["first_name"],
          middleName: userData["middle_name"],
          suffix: userData["suffix"],
          email: userData["email"],
          program: userData["program"],
          yearLevel: userData["year_level"],
          contactNumber: userData["contact_number"],
          avatarPath: userData["avatar_path"] ?? "",
        );

        // Route based on user type
        if (userType == "Admin") {
          await Future.delayed(
              const Duration(milliseconds: 500)); // small delay to show loading
          if (mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminDashboard()));
          }
        } else if (userType == "Student") {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const UserDashApp()));
          }
        } else {
          if (mounted) {
            showWarningSnackBar(context,
                title: 'Login Error', message: 'Unknown user type!');
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        // Handle custom backend errors
        final String code = data["retCode"];
        final String message = data["message"] ?? "Login failed.";

        if (mounted) {
          switch (code) {
            case "401":
              //showErrorSnackBar(context, title: "Login Failed", message: message);
              break;
            case "403":
              showWarningSnackBar(context,
                  title: "Account Blocked", message: message);
              break;
            case "400":
              showWarningSnackBar(context,
                  title: "Invalid Request", message: message);
              break;
            default:
              showErrorSnackBar(context,
                  title: "Login Failed", message: message);
          }
        }
      }
    } on DioException catch (e) {
      final res = e.response;
      if (res != null && res.data != null) {
        final String message = res.data["message"] ?? "Unexpected error.";
        final String code = res.data["retCode"] ?? "Unknown";

        if (mounted) {
          if (code == "500") {
            showErrorSnackBar(context, title: "Server Error", message: message);
          } else {
            showWarningSnackBar(context,
                title: "Login Failed", message: message);
          }
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context,
              title: "Connection Error",
              message: "Could not connect to server.");
        }
      }
    } finally {
      if (mounted && !_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 1000;

                return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: isWideScreen
                        ? Row(
                            children: [
                              // 📌 Left Side: Logo with Full Teal Background
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: AdminColor.secondaryBackgroundColor,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/admin_logo_white.png',
                                        width: constraints.maxWidth > 1200
                                            ? 300
                                            : 250,
                                        height: constraints.maxWidth > 1200
                                            ? 300
                                            : 250,
                                        fit: BoxFit.contain,
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0,
                                            -15), // Moves text **UPWARD** by 20 pixels
                                        child: Column(
                                          children: [
                                            Text(
                                              "BOOKEASE",
                                              style: GoogleFonts.poppins(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w800,
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                            const SizedBox(
                                                height: 2), // Minimal spacing
                                            Text(
                                              "BORROW SMART",
                                              style: GoogleFonts.poppins(
                                                fontSize: 24,
                                                color: const Color.fromARGB(
                                                    255, 249, 249, 249),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // 📌 Right Side: Login Form
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 50,
                                    left: 50,
                                    right: 50,
                                  ),
                                  child: _buildLoginForm(context, isWideScreen),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Image.asset(
                                    'assets/images/admin_logo_green.png',
                                    height: 150,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildLoginForm(context, isWideScreen),
                              ],
                            ),
                          ));
              },
            ),
          ),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: SvgLoadingScreen(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, bool isWideScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Show "WELCOME BACK ADMIN!" only on large screens
          if (isWideScreen)
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                "WELCOME BACK ADMIN!",
                style: GoogleFonts.poppins(
                  fontSize: 34, // ✅ Larger Text
                  fontWeight: FontWeight.w900, // ✅ Extra Bold
                  color: AdminColor.secondaryBackgroundColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // 📌 ID Number Field
          TextField(
            controller: _idController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
            ],
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'ID Number',
              labelStyle: const TextStyle(color: Colors.grey),
              floatingLabelStyle:
                  const TextStyle(color: AdminColor.secondaryBackgroundColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: AdminColor.secondaryBackgroundColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 📌 Password Field
          PasswordField(controller: _passwordController),
          const SizedBox(height: 10),

          // 📌 Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                fadePush(context, EmailForgotPassword());
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 📌 Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColor.secondaryBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _loginUser();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 📌 Navigate to SignUp Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              GestureDetector(
                onTap: () {
                  fadePush(context, const MultiStepSignUpScreen());
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: AdminColor.secondaryBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: isObscured,
      cursorColor: AdminColor.secondaryBackgroundColor,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle:
            const TextStyle(color: AdminColor.secondaryBackgroundColor),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.grey, width: 1.5), // ✅ Fixed border error
          borderRadius: BorderRadius.circular(10), // ✅ Ensure this works
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AdminColor.secondaryBackgroundColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility : Icons.visibility_off,
            color: AdminColor.secondaryBackgroundColor,
          ),
          onPressed: () {
            setState(() {
              isObscured = !isObscured;
            });
          },
        ),
      ),
    );
  }
}
