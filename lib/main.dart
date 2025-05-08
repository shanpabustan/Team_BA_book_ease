import 'package:book_ease/screens/admin/managebook/book_management_table.dart';
import 'package:book_ease/screens/user/home/user_dashboard.dart';
import 'package:book_ease/screens/user/library/library_main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:book_ease/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:book_ease/provider/book_provider.dart';
//import 'package:book_ease/provider/notification_provider.dart';

const Color secondaryColor = Color.fromRGBO(49, 120, 115, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();

  // ✅ Initialize and load user data from SharedPreferences
  final userData = UserData();
  await userData.loadFromPrefs();

  runApp(MyApp(userData: userData));
}

Future<void> requestPermissions() async {
  if (kIsWeb) {
    print("Skipping permission requests on web.");
    return;
  }
  await Permission.camera.request();
  await Permission.photos.request();
}

class MyApp extends StatelessWidget {
  final UserData userData;

  const MyApp({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final ThemeData baseLight = ThemeData.light();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>.value(value: userData),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: baseLight.copyWith(
          primaryColor: secondaryColor,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(baseLight.textTheme),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        home: userData.isLoggedIn
            ? (userData.userType == "Admin"
                ? AdminDashboard()
                : (userData.userType == "Student"
                    ? const UserDashApp()
                    : const LoginScreen()))
            : const LoginScreen(),
      ),
    );
  }
}
