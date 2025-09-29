class Reservation {
  const Reservation({
    required this.id,
    required this.offerId,
    required this.title,
    required this.quantity,
    required this.createdAt,
    this.stockItemId,
  });

  final String id;
  final String offerId;
  final String title;
  final int quantity;
  final String? stockItemId;
  final DateTime createdAt;
}
