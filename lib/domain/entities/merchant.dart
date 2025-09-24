/// Entité représentant un commerçant
class Merchant {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final bool isFavorite;
  final List<String>? tags;
  final String cuisineType;
  final double rating;
  final String distanceText;
  final bool hasActiveOffer;
  final double originalPrice;
  final double discountedPrice;
  final double minPrice;
  final int availableOffers;
  final String pickupTime;
  final int discountPercentage;

  const Merchant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
    this.tags,
    required this.cuisineType,
    required this.rating,
    required this.distanceText,
    this.hasActiveOffer = false,
    required this.originalPrice,
    required this.discountedPrice,
    required this.minPrice,
    required this.availableOffers,
    required this.pickupTime,
    required this.discountPercentage,
  });
}
