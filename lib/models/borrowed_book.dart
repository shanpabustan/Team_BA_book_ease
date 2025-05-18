import 'package:json_annotation/json_annotation.dart';

part 'borrowed_book.g.dart';

@JsonSerializable()
class BorrowedBook {
  @JsonKey(name: 'book_id')
  final int bookId;
  final String title;
  final String picture;
  
  @JsonKey(name: 'borrow_date')
  final DateTime borrowDate;
  
  @JsonKey(name: 'due_date')
  final DateTime dueDate;
  final String status;

  BorrowedBook({
    required this.bookId,
    required this.title,
    required this.picture,
    required this.borrowDate,
    required this.dueDate,
    required this.status,
  });

  factory BorrowedBook.fromJson(Map<String, dynamic> json) => _$BorrowedBookFromJson(json);
  Map<String, dynamic> toJson() => _$BorrowedBookToJson(this);
} 