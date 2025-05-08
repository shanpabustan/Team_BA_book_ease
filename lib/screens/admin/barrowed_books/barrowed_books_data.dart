// borrowed_book.dart

import 'package:flutter/src/material/data_table.dart';

class BorrowedBookAdmin {
  final int borrowID;
  final int reservationID;
  final String userID;
  final String name;
  final int bookID;
  final String bookName;
  final String status;
  final String borrowDate;
  final String dueDate;
  final String returnDate;
  final String conditionBefore;
  final String conditionAfter;
  final double penalty;

  BorrowedBookAdmin({
    required this.borrowID,
    required this.reservationID,
    required this.userID,
    required this.name,
    required this.bookID,
    required this.bookName,
    required this.status,
    required this.borrowDate,
    required this.dueDate,
    required this.returnDate,
    required this.conditionBefore,
    required this.conditionAfter,
    required this.penalty,
  });

  // Factory method to create a BorrowedBook instance from JSON data
  factory BorrowedBookAdmin.fromJson(Map<String, dynamic> json) {
    return BorrowedBookAdmin(
      borrowID: json['borrow_id'],
      reservationID: json['reservation_id'],
      userID: json['user_id'],
      name: json['full_name'] ?? 'Unknown',
      bookID: json['book_id'],
      bookName: json['book_title'] ?? 'Untitled',
      status: json['status'] ?? 'N/A',
      borrowDate: json['borrow_date'] ?? '—',
      dueDate: json['due_date'] ?? '—',
      returnDate: json['return_date'] ?? 'Pending',
      conditionBefore: json['book_condition_before'] ?? '—',
      conditionAfter: json['book_condition_after'] ?? 'Not yet returned',
      penalty: json['penalty_amount'] ?? 0.0,
    );
  }

String getField(String field) {
    switch (field) {
      case 'borrowID':
        return borrowID.toString();
      case 'reservationID':
        return reservationID.toString();
      case 'userID':
        return userID;
      case 'name':
        return name;
      case 'bookID':
        return bookID.toString();
      case 'bookName':
        return bookName;
      case 'status':
        return status;
      case 'borrowDate':
        return borrowDate;
      case 'dueDate':
        return dueDate;
      case 'returnDate':
        return returnDate;
      case 'conditionBefore':
        return conditionBefore;
      case 'conditionAfter':
        return conditionAfter;
      case 'penalty':
        return penalty.toString();
      default:
        return '';
    }
  }
  
}
