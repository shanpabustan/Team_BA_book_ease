import 'package:book_ease/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:book_ease/screens/auth/change-password.dart';
import 'package:book_ease/screens/user/account/personal_view.dart';
import 'package:book_ease/data/personal_data.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/main.dart';
import 'package:book_ease/base_url.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _profileImage;
  String? _selectedAvatarPath;
  final Dio _dio = Dio();

  final List<String> _avatarChoices = [
    'assets/icons/j-rizz.png',
    'assets/icons/boy-icon.png',
    'assets/icons/girl-icon.png',
    'assets/icons/girl-2.png',
    'assets/icons/reading_book.png',
    'assets/icons/student-boy.png',
    'assets/images/bini.jpg',
    'assets/images/pulgoso.jpg',
  ];

  Future<Map<String, dynamic>> _loadPersonalInfo() async {
    return await fetchPersonalInfo();
  }

  Future<void> _updateAvatar(String avatarPath) async {
    final userData = Provider.of<UserData>(context, listen: false);

    try {
      Response response = await _dio.post(
        "${ApiConfig.baseUrl}/stud/add-pic", // Replace with actual API URL
        data: {
          "user_id": userData.userID,
          "avatar_path": avatarPath,
        },
      );

      if (response.statusCode == 200) {
        userData.setAvatarPath(avatarPath); // Update locally

        setState(() {
          _selectedAvatarPath = avatarPath;
          _profileImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Avatar updated successfully!")),
        );
      } else {
        throw Exception("Failed to update avatar");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating avatar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final userData = Provider.of<UserData>(context);
    String fullName =
        "${userData.firstName} ${userData.middleName.isNotEmpty ? userData.middleName + " " : ""}${userData.lastName}${userData.suffix.isNotEmpty ? " " + userData.suffix : ""}";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Account",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadPersonalInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: secondaryColor,
                        height: screenHeight * 0.15,
                      ),
                      Positioned(
                        top: screenHeight * 0.07,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: secondaryColor,
                                  width: 6,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: isSmallScreen ? 70 : 80,
                                backgroundColor: Colors.white,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : (_selectedAvatarPath != null
                                        ? AssetImage(_selectedAvatarPath!)
                                        : AssetImage(userData.avatarPath.isNotEmpty
                                            ? userData.avatarPath
                                            : 'assets/icons/boy-icon.png')) as ImageProvider,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120),
                  _buildProfileInfo(fullName),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Choose Your Avatar",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: _avatarChoices.length,
                                  itemBuilder: (context, index) {
                                    final avatarPath = _avatarChoices[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        _updateAvatar(avatarPath);
                                      },
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            AssetImage(avatarPath),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        isScrollControlled: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Choose Avatar'),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileOptions(context, isSmallScreen),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileInfo(String fullName) {
    return Column(
      children: [
        Text(
          fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8.0 : 16.0),
      child: Column(
        children: [
          _buildProfileOption(
            Icons.person,
            'Personal Information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalInfoScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(Icons.book, 'Borrowing Details'),
          _buildProfileOption(
            Icons.lock,
            'Change Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreatePasswordScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(
            Icons.logout,
            'Logout',
            isLogout: true,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogBookEaseApp(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildProfileOption(IconData icon, String title,
      {bool isLogout = false, VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.teal),
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        trailing:
            isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
