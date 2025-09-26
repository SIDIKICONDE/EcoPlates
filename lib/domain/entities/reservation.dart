class Reservation {
  const Reservation({
    required this.id,
    required this.offerId,
    required this.title,
    required this.quantity,
    this.stockItemId,
    required this.createdAt,
  });

  final String id;
  final String offerId;
  final String title;
  final int quantity;
  final String? stockItemId;
  final DateTime createdAt;
}
