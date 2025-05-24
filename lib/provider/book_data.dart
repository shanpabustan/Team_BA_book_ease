import 'dart:math';

class Book {
  final int bookId;
  final String title;
  final String author;
  final int copies;
  //final int totalCopies;
  final String year;
  final String description;
  final String image;
  final String isbn;
  final String shelfLocation;
  final String librarySection;
  final String category;
  final int reserveCount;

  Book({
    required this.bookId,
    required this.title,
    required this.author,
    required this.copies,
    //required this.totalCopies,
    required this.year,
    required this.description,
    required this.image,
    required this.isbn,
    required this.shelfLocation,
    required this.librarySection,
    required this.category,
    required this.reserveCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    print('Processing book JSON: ${json['title']} - Category: ${json['category']}');
    final category = json['category']?.toString().trim() ?? "Unknown";
    print('Processed category: $category');
    
    // Handle the base64 image data
    String imageData = json['picture'] ?? '';
    print('Raw image data length: ${imageData.length}');
    print('Raw image data starts with: ${imageData.substring(0, min(50, imageData.length))}');
    
    if (imageData.isNotEmpty) {
      if (!imageData.startsWith('data:image')) {
        print('Adding data URI prefix to image');
        imageData = 'data:image/jpeg;base64,$imageData';
      } else {
        print('Image already has data URI prefix');
      }
    } else {
      print('Empty image data received');
    }
    
    print('Final image data length: ${imageData.length}');
    print('Final image data starts with: ${imageData.substring(0, min(50, imageData.length))}');
    
    return Book(
      bookId: json['book_id'],
      title: json['title'],
      author: json['author'],
      copies: json['total_copies'],
      //totalCopies: json['total_copies'],
      year: json['year_published']?.toString() ?? "Unknown",
      description: json['description'],
      image: imageData,
      isbn: json['isbn'] ?? "Unknown",
      shelfLocation: json['shelf_location'] ?? "Unknown",
      librarySection: json['library_section'] ?? "Unknown",
      category: category,
      reserveCount: json['reserved_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_id': bookId,
      'title': title,
      'author': author,
      'copies': copies,
      'year': year,
      'description': description,
      'image': image,
      'isbn': isbn,
      'shelfLocation': shelfLocation,
      'librarySection': librarySection,
      'category': category,
      'reserveCount': reserveCount,
    };
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
  String rawImage = json['picture'] ?? '';
  

  final cleanedImage = rawImage.split('base64,').last;

  return BorrowedBook(
    bookId: json['book_id'],
    title: json['title'],
    copies: json['copies'],
    dueDate: json['due_date'],
    image: cleanedImage,
    author: json['author'] ?? "Unknown",
    year: json['year_published']?.toString() ?? "Unknown",
    isbn: json['isbn'] ?? "Unknown",
    shelfLocation: json['shelf_location'] ?? "Unknown",
    librarySection: json['library_section'] ?? "Unknown",
    description: json['description'] ?? "No description",
  );
}
}
