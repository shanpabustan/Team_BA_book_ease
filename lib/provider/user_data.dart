import 'package:flutter/foundation.dart';

// Define a BorrowedBook model
class BorrowedBook {
  final int reservationID;
  final String userID;
  final int bookID;
  final String title;
  final String picture;
  final DateTime borrowDate;
  final DateTime dueDate;

  BorrowedBook({
    required this.reservationID,
    required this.userID,
    required this.bookID,
    required this.title,
    required this.picture,
    required this.borrowDate,
    required this.dueDate,
  });
}

class UserData with ChangeNotifier {
  String _userID = '';
  String _userType = '';
  String _lastName = '';
  String _firstName = '';
  String _middleName = '';
  String _suffix = '';
  String _email = '';
  String _program = '';
  String _yearLevel = '';
  String _contactNumber = '';
  String _avatarPath = ''; // Added avatarPath field
  List<BorrowedBook> _borrowedBooks = []; // New field for borrowed books

  // Getters
  String get userID => _userID;
  String get userType => _userType;
  String get lastName => _lastName;
  String get firstName => _firstName;
  String get middleName => _middleName;
  String get suffix => _suffix;
  String get email => _email;
  String get program => _program;
  String get yearLevel => _yearLevel;
  String get contactNumber => _contactNumber;
  String get avatarPath => _avatarPath; // Getter for avatarPath
  List<BorrowedBook> get borrowedBooks => _borrowedBooks; // Getter for borrowed books

  // Setters to update the data
  void setUserData({
    required String userID,
    required String userType,
    required String lastName,
    required String firstName,
    required String middleName,
    required String suffix,
    required String email,
    required String program,
    required String yearLevel,
    required String contactNumber,
    required String avatarPath, // Added avatarPath
  }) {
    _userID = userID;
    _userType = userType;
    _lastName = lastName;
    _firstName = firstName;
    _middleName = middleName;
    _suffix = suffix;
    _email = email;
    _program = program;
    _yearLevel = yearLevel;
    _contactNumber = contactNumber;
    _avatarPath = avatarPath; // Save avatarPath

    notifyListeners(); // Notify listeners about data change
  }

  // Function to update borrowed books
  void setBorrowedBooks(List<BorrowedBook> books) {
    _borrowedBooks = books;
    notifyListeners();
  }

  // Function to update avatarPath
  void setAvatarPath(String path) {
    _avatarPath = path;
    notifyListeners();
  }

  void updateUser({
    required String firstName,
    required String lastName,
    required String middleName,
    required String suffix,
    required String contactNumber,
    String? program, // Allow null, but handle it properly
    String? yearLevel,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _middleName = middleName;
    _suffix = suffix;
    _contactNumber = contactNumber;
    _program = program ?? _program; // Retain old value if null
    _yearLevel = yearLevel ?? _yearLevel;

    notifyListeners();
  }
}
