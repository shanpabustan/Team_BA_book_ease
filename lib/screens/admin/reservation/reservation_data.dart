class Reservation {
  final int reservationId;
  final String userId;
  final String fullName;
  final int bookId;
  final String bookTitle;
  final DateTime preferredPickupDate;
  final String status;
  final DateTime createdAt;

  Reservation({
    required this.reservationId,
    required this.userId,
    required this.fullName,
    required this.bookId,
    required this.bookTitle,
    required this.preferredPickupDate,
    required this.status,
    required this.createdAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json['reservation_id'],
      userId: json['user_id'],
      fullName: json['full_name'],
      bookId: json['book_id'],
      bookTitle: json['book_title'],
      preferredPickupDate: DateTime.parse(json['preferred_pickup_date']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}