List<Map<String, String>> getBooks(String category) {
  switch (category) {
    case "Recommendations":
      return [
        {
          "title": "Percy Jackson",
          "copies": "5 copies available",
          "image": "assets/images/percy-book.jpg"
        },
        {
          "title": "Harry Potter",
          "copies": "3 copies available",
          "image": "assets/images/harry-book.jpg"
        },
      ];
    case "Trending Books":
      return [
        {
          "title": "The Alchemist",
          "copies": "7 copies available",
          "image": "assets/images/harry-book.jpg"
        },
        {
          "title": "Atomic Habits",
          "copies": "6 copies available",
          "image": "assets/images/percy-book.jpg"
        },
      ];
    case "Borrowed Books":
      return [
        {
          "title": "1984",
          "copies": "2 copies left",
          "image": "assets/images/percy-book.jpg"
        },
        {
          "title": "The Hobbit",
          "copies": "1 copy left",
          "image": "assets/images/harry-book.jpg"
        },
      ];
    default:
      return [];
  }
}
