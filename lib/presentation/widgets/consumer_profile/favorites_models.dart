/// Modèles de données pour les favoris du consommateur
library;

class FavoritePlace {

  const FavoritePlace({
    required this.name,
    required this.address,
    required this.rating,
    required this.visitCount,
  });
  final String name;
  final String address;
  final double rating;
  final int visitCount;
}

class FavoriteDish {

  const FavoriteDish({
    required this.name,
    required this.restaurantName,
    required this.price,
    required this.orderCount,
  });
  final String name;
  final String restaurantName;
  final double price;
  final int orderCount;
}
