// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrowed_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowedBook _$BorrowedBookFromJson(Map<String, dynamic> json) => BorrowedBook(
      bookId: (json['book_id'] as num).toInt(),
      title: json['title'] as String,
      picture: json['picture'] as String,
      borrowDate: DateTime.parse(json['borrow_date'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      status: json['status'] as String,
      source: json['source'] as String,
    );

Map<String, dynamic> _$BorrowedBookToJson(BorrowedBook instance) =>
    <String, dynamic>{
      'book_id': instance.bookId,
      'title': instance.title,
      'picture': instance.picture,
      'borrow_date': instance.borrowDate.toIso8601String(),
      'due_date': instance.dueDate.toIso8601String(),
      'status': instance.status,
      'source': instance.source,
    };
