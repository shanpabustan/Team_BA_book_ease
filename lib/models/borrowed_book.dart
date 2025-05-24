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
  final String source;

  BorrowedBook({
    required this.bookId,
    required this.title,
    required this.picture,
    required this.borrowDate,
    required this.dueDate,
    required this.status,
    required this.source,
  });

  factory BorrowedBook.fromJson(Map<String, dynamic> json) {
    print('Parsing BorrowedBook from JSON: $json');
    
    // Handle the base64 prefix for picture if it doesn't exist
    if (json['picture'] != null && json['picture'].toString().isNotEmpty && !json['picture'].toString().startsWith('data:image')) {
      json['picture'] = 'data:image/jpeg;base64,${json['picture']}';
    }
    
    final book = _$BorrowedBookFromJson(json);
    print('Created BorrowedBook: ${book.title} (Status: ${book.status}, Source: ${book.source})');
    return book;
  }
  
  Map<String, dynamic> toJson() => _$BorrowedBookToJson(this);

  // Helper method to get the display status
  String get displayStatus {
    print('Getting display status for book: $title');
    print('Raw status: $status, Source: $source');
    
    if (source == 'borrowed') {
      switch (status.toLowerCase()) {
        case 'pending':
          return 'To Return';
        case 'cancelled':
          return 'Cancelled';
        case 'returned':
          return 'Returned';
        case 'overdue':
          return 'Overdue';
        default:
          print('Unknown borrowed status: $status');
          return status;
      }
    } else if (source == 'reservation') {
      switch (status.toLowerCase()) {
        case 'pending':
          return 'To Pick Up';
        case 'cancelled':
          return 'Cancelled';
        case 'picked up':
          return 'Picked Up';
        default:
          print('Unknown reservation status: $status');
          return status;
      }
    }
    
    print('Unknown source: $source');
    return status;
  }
} 