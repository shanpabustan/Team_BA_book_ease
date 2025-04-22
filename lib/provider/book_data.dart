class Book {
  final int bookId;
  final String title;
  final String author;
  final int copies;
  final String year;
  final String description;
  final String image;
  final String isbn;
  final String shelfLocation;
  final String librarySection;
  final int reserveCount;

  Book({
    required this.bookId,
    required this.title,
    required this.author,
    required this.copies,
    required this.year,
    required this.description,
    required this.image,
    required this.isbn,
    required this.shelfLocation,
    required this.librarySection,
    required this.reserveCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'],
      title: json['title'],
      author: json['author'],
      copies: json['available_copies'],
      year: json['year_published']?.toString() ?? "Unknown",
      description: json['description'],
      image: json['picture'],
      isbn: json['isbn'] ?? "Unknown",
      shelfLocation: json['shelf_location'] ?? "Unknown",
      librarySection: json['library_section'] ?? "Unknown",
      reserveCount: json['reserved_count'] ?? 0,
    );
  }
}

class BorrowedBook {
  final int bookId;
  final String title;
  final int copies;
  final String dueDate;
  final String image;
    final String author;
  final String year;
  final String isbn;
  final String shelfLocation;
  final String librarySection;
  final String description;

  BorrowedBook({
    required this.bookId,
    required this.title,
    required this.copies,
    required this.dueDate,
    required this.image,
    required this.author,
    required this.year,
    required this.isbn,
    required this.shelfLocation,
    required this.librarySection,
    required this.description,
  });

  factory BorrowedBook.fromJson(Map<String, dynamic> json) {
    return BorrowedBook(
      bookId: json['book_id'],
      title: json['title'],
      copies: json['copies'],
      dueDate: json['due_date'],
      image: json['picture'],
      author: json['author'] ?? "Unknown",
      year: json['year_published']?.toString() ?? "Unknown",
      isbn: json['isbn'] ?? "Unknown",
      shelfLocation: json['shelf_location'] ?? "Unknown",
      librarySection: json['library_section'] ?? "Unknown",
      description: json['description'] ?? "No description",
    );
  }
}
