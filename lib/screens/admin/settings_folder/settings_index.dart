import 'package:flutter/material.dart';

class SettingsMain extends StatefulWidget {
  const SettingsMain({super.key});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    MyProfilePage(),
    AccountSecurityPage(),
    EndSemesterPage(),
  ];

  final List<String> menuTitles = [
    'My Profile',
    'Account Security',
    'End Semester',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Side Navigation Menu
        Container(
          width: 220,
          color: const Color(0xFFEFF4F4),
          child: ListView.builder(
            itemCount: menuTitles.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(
                  _getIcon(index),
                  color: selectedIndex == index
                      ? const Color(0xFF005F5F)
                      : Colors.black54,
                ),
                title: Text(
                  menuTitles[index],
                  style: TextStyle(
                    color: selectedIndex == index
                        ? const Color(0xFF005F5F)
                        : Colors.black87,
                    fontWeight: selectedIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: selectedIndex == index,
                onTap: () {
                  setState(() => selectedIndex = index);
                },
              );
            },
          ),
        ),

        // Right Content Area
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: pages[selectedIndex],
          ),
        ),
      ],
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.lock;
      case 2:
        return Icons.school;
      default:
        return Icons.settings;
    }
  }
}

// ---------------- My Profile Page ----------------

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Profile Settings",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=65', // Placeholder image
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Adminname",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("Librarian"),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Edit"),
                ),
              ],
            ),
            const SizedBox(width: 40),

            // Personal Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text("Personal Information",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 6),
                      Text("Edit", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    runSpacing: 12,
                    spacing: 20,
                    children: const [
                      _ProfileField(label: "First Name", value: "Andrey"),
                      _ProfileField(label: "Last Name", value: "Din"),
                      _ProfileField(
                          label: "Email Address", value: "andreydin@gmail.com"),
                      _ProfileField(
                          label: "Phone Number", value: "+63 912456789"),
                      _ProfileField(label: "Role", value: "Librarian"),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFF3F4F6),
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Account Security Page ----------------

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Account Security Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
    );
  }
}

// ---------------- End Semester Page ----------------

class EndSemesterPage extends StatelessWidget {
  const EndSemesterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("End Semester Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
    );
  }
}
