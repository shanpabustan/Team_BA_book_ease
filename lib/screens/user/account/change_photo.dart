import 'package:book_ease/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_ease/screens/auth/change-password.dart';
import 'package:book_ease/screens/user/account/personal_view.dart';
import 'package:book_ease/data/personal_data.dart';
import 'package:provider/provider.dart';
import 'package:book_ease/provider/user_data.dart';
import 'package:book_ease/main.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  IconData? _selectedIcon;
  final List<IconData> _iconChoices = [
    Icons.person,
    Icons.account_circle,
    Icons.face,
    Icons.school,
    Icons.book,
    Icons.star,
  ];

  // Function to load personal information
  Future<Map<String, dynamic>> _loadPersonalInfo() async {
    return await fetchPersonalInfo();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final userData = Provider.of<UserData>(context);
    String fullName = "${userData.firstName} ${userData.middleName.isNotEmpty ? userData.middleName + " " : ""}${userData.lastName}${userData.suffix.isNotEmpty ? " " + userData.suffix : ""}";

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
                        child: CircleAvatar(
                          radius: isSmallScreen ? 70 : 80,
                          backgroundColor: Colors.white,
                          child: _selectedIcon != null
                              ? Icon(_selectedIcon, size: isSmallScreen ? 60 : 70, color: Colors.teal)
                              : null,
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
                          return SizedBox(
                            height: 250,
                            child: GridView.count(
                              crossAxisCount: 3,
                              children: _iconChoices.map((iconData) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIcon = iconData;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                    elevation: 4,
                                    child: Center(
                                      child: Icon(iconData, size: 40, color: Colors.teal),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Choose Profile Icon'),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileOptions(context, isSmallScreen, snapshot.data!),
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

  Widget _buildProfileOptions(
      BuildContext context, bool isSmallScreen, Map<String, dynamic> userData) {
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
      ),
    );
  }
}
