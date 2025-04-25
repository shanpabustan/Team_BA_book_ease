class UserProfile {
  String firstName;
  String lastName;
  String email;
  String idNumber;
  String role;
  String phoneNumber;
  String imageUrl;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.idNumber,
    required this.role,
    required this.phoneNumber,
    required this.imageUrl,
  });

  // Simulate loading from backend
  static Future<UserProfile> fetchDummy() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network
    return UserProfile(
      firstName: "Andrey",
      lastName: "Din",
      email: "andreydin@gmail.com",
      idNumber: "202501234",
      role: "Librarian",
      phoneNumber: "09123456789",
      imageUrl: "https://i.pravatar.cc/150?img=65",
    );
  }
}
