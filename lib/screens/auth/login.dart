import 'package:book_ease/base_url.dart';
import 'package:book_ease/utils/success_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:book_ease/screens/user/home/user_dashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'multisignup.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:book_ease/provider/user_data.dart'; // Import your UserData provider
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';

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

  void _loginUser() async {
    final Dio dio = Dio();

    // 🔥 Use the correct API URL (Replace with your actual API URL if needed)
    final String apiUrl =
        "${ApiConfig.baseUrl}/stud/login"; // Replace with your API URL

    try {
      // Make POST request with the correct body
      Response response = await dio.post(
        apiUrl,
        data: {
          "user_id": _idController.text,
          "password": _passwordController.text,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      // Checking if the response is successful
      if (response.data["retCode"] == "200") {
        final userData = response.data["data"];
        String userType = response.data["data"]["user_type"];

        debugPrint("Response Data: ${response.data}");

        if (mounted) {
          showSuccessSnackBar(
            context,
            title: 'Login Successful!',
            message: 'You have logged in successfully.',
          );
        }

        // Set user data in the UserData provider
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

        // Navigate based on the user type
        switch (userType) {
          case "Admin":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminDashboard()), // Assuming you have this route
            );
            break;
          case "Student":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserDashApp()),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Unknown user type!")),
            );
            break;
        }
      } else {
        // Show error message if login fails
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.data["message"] ?? 'Unknown error')),
          );
        }
      }
    } catch (e) {
      debugPrint("API ERROR: ${e.toString()}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to login. Please try again.")),
        );
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
      body: SingleChildScrollView(
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
                            color: Colors.teal,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/admin_logo.png',
                                  width:
                                      constraints.maxWidth > 1200 ? 400 : 350,
                                  height:
                                      constraints.maxWidth > 1200 ? 400 : 350,
                                  fit: BoxFit.contain,
                                ),
                                Transform.translate(
                                  offset: const Offset(0,
                                      -95), // Moves text **UPWARD** by 20 pixels
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Image.asset(
                              'assets/images/logo-removebg-preview.png',
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildLoginForm(context, isWideScreen),
                        ],
                      ),
                    ),
            );
          },
        ),
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
                  color: Colors.teal,
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
              floatingLabelStyle: const TextStyle(color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal, width: 2),
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
              onPressed: () {},
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
                backgroundColor: Colors.teal,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MultiStepSignUpScreen(), // ✅ Navigates to Signup
                    ),
                  );
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.teal,
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
      cursorColor: Colors.teal,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.grey, width: 1.5), // ✅ Fixed border error
          borderRadius: BorderRadius.circular(10), // ✅ Ensure this works
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility : Icons.visibility_off,
            color: Colors.teal,
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
