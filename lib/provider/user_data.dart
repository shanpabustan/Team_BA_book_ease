import 'package:book_ease/provider/book_data.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a UserBorrowedBook model
class UserBorrowedBook {
  final int reservationID;
  final String userID;
  final Book book;
  final DateTime borrowDate;
  final DateTime dueDate;

  UserBorrowedBook({
    required this.reservationID,
    required this.userID,
    required this.book,
    required this.borrowDate,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() => {
        'reservationID': reservationID,
        'userID': userID,
        'book': book.toJson(),
        'borrowDate': borrowDate.toIso8601String(),
        'dueDate': dueDate.toIso8601String(),
      };

  factory UserBorrowedBook.fromJson(Map<String, dynamic> json) => UserBorrowedBook(
        reservationID: json['reservationID'],
        userID: json['userID'],
        book: Book.fromJson(json['book']),
        borrowDate: DateTime.parse(json['borrowDate']),
        dueDate: DateTime.parse(json['dueDate']),
      );
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
  String _avatarPath = '';
 

  bool _isLoggedIn = false;

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
  String get avatarPath => _avatarPath;
  bool get isLoggedIn => _isLoggedIn;

  // Setters
  Future<void> setUserData({
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
    required String avatarPath,
  }) async {
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
    _avatarPath = avatarPath;
    _isLoggedIn = true;

    await saveToPrefs();
    notifyListeners();
  }

  Future<void> saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setString('userID', _userID);
    await prefs.setString('userType', _userType);
    await prefs.setString('lastName', _lastName);
    await prefs.setString('firstName', _firstName);
    await prefs.setString('middleName', _middleName);
    await prefs.setString('suffix', _suffix);
    await prefs.setString('email', _email);
    await prefs.setString('program', _program);
    await prefs.setString('yearLevel', _yearLevel);
    await prefs.setString('contactNumber', _contactNumber);
    await prefs.setString('avatarPath', _avatarPath);
    
  }

  Future<void> loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!_isLoggedIn) return;

    _userID = prefs.getString('userID') ?? '';
    _userType = prefs.getString('userType') ?? '';
    _lastName = prefs.getString('lastName') ?? '';
    _firstName = prefs.getString('firstName') ?? '';
    _middleName = prefs.getString('middleName') ?? '';
    _suffix = prefs.getString('suffix') ?? '';
    _email = prefs.getString('email') ?? '';
    _program = prefs.getString('program') ?? '';
    _yearLevel = prefs.getString('yearLevel') ?? '';
    _contactNumber = prefs.getString('contactNumber') ?? '';
    _avatarPath = prefs.getString('avatarPath') ?? '';

    

    notifyListeners();
  }

  void logout() async {
    _userID = '';
    _userType = '';
    _lastName = '';
    _firstName = '';
    _middleName = '';
    _suffix = '';
    _email = '';
    _program = '';
    _yearLevel = '';
    _contactNumber = '';
    _avatarPath = '';
    _isLoggedIn = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }



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
    String? program,
    String? yearLevel,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _middleName = middleName;
    _suffix = suffix;
    _contactNumber = contactNumber;
    _program = program ?? _program;
    _yearLevel = yearLevel ?? _yearLevel;

    notifyListeners();
  }
}
