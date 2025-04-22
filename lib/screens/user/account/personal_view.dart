import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:book_ease/provider/user_data.dart'; // Import your UserData provider
import 'personal_edit.dart';



class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access user data from the provider
    final userData = Provider.of<UserData>(context);

    // Construct full name properly with optional suffix
    final fullName = userData.suffix.isNotEmpty
        ? "${userData.firstName} ${userData.middleName} ${userData.lastName}, ${userData.suffix}"
        : "${userData.firstName} ${userData.middleName} ${userData.lastName}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _sectionTitle("Basic Info", onEditPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalInfoEditScreen(), // No data passed
            ),
          );
            }),
            _buildInfoTile(Icons.badge, userData.userID, "ID Number"),
            _buildInfoTile(Icons.person, fullName, "Fullname"),
            _buildInfoTile(Icons.school, userData.program, "Course"),
            _buildInfoTile(Icons.grade, userData.yearLevel, "Year level"),
            const SizedBox(height: 20),
            _sectionTitle("Contacts"),
            _buildInfoTile(Icons.email, userData.email, "Email"),
            _buildInfoTile(Icons.phone, userData.contactNumber, "Phone number"),
          ],
        ),
      ),
    );
  }

  /// Creates a section title with an optional Edit button aligned to the right.
  Widget _sectionTitle(String title, {VoidCallback? onEditPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        if (onEditPressed != null)
          TextButton.icon(
            onPressed: onEditPressed,
            icon: const Icon(Icons.edit, size: 18, color: Colors.teal),
            label: const Text(
              "Edit",
              style: TextStyle(color: Colors.teal, fontFamily: 'Poppins'),
            ),
          ),
      ],
    );
  }

  /// Reusable info tile widget
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Poppins')),
      ),
    );
  }
}
