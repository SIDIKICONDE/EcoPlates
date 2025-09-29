import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Énumération des onglets disponibles pour l'interface consommateur
enum ConsumerTab {
  discover,
  browse,
  favorites,
  cart,
  delivery,
  profile;

  /// Label localisé de l'onglet
  String get label {
    switch (this) {
      case ConsumerTab.discover:
        return 'Découvrir';
      case ConsumerTab.browse:
        return 'Parcourir';
      case ConsumerTab.favorites:
        return 'Favoris';
      case ConsumerTab.cart:
        return 'Panier';
      case ConsumerTab.delivery:
        return 'Livraison';
      case ConsumerTab.profile:
        return 'Profil';
    }
  }

  /// Label court pour affichage mobile
  String get shortLabel {
    switch (this) {
      case ConsumerTab.discover:
        return 'Découvrir';
      case ConsumerTab.browse:
        return 'Parcourir';
      case ConsumerTab.favorites:
        return 'Favoris';
      case ConsumerTab.cart:
        return 'Panier';
      case ConsumerTab.delivery:
        return 'Livraison';
      case ConsumerTab.profile:
        return 'Profil';
    }
  }

  /// Emoji associé à l'onglet
  String get emoji {
    switch (this) {
      case ConsumerTab.discover:
        return '🏠';
      case ConsumerTab.browse:
        return '🔍';
      case ConsumerTab.favorites:
        return '❤️';
      case ConsumerTab.cart:
        return '🛒';
      case ConsumerTab.delivery:
        return '🚚';
      case ConsumerTab.profile:
        return '👤';
    }
  }

  /// Icône Material pour l'onglet
  IconData get icon {
    switch (this) {
      case ConsumerTab.discover:
        return Icons.home_outlined;
      case ConsumerTab.browse:
        return Icons.search_outlined;
      case ConsumerTab.favorites:
        return Icons.favorite_border;
      case ConsumerTab.cart:
        return Icons.shopping_cart_outlined;
      case ConsumerTab.delivery:
        return Icons.local_shipping_outlined;
      case ConsumerTab.profile:
        return Icons.person_outline;
    }
  }

  /// Icône Material sélectionnée pour l'onglet
  IconData get activeIcon {
    switch (this) {
      case ConsumerTab.discover:
        return Icons.home;
      case ConsumerTab.browse:
        return Icons.search;
      case ConsumerTab.favorites:
        return Icons.favorite;
      case ConsumerTab.cart:
        return Icons.shopping_cart;
      case ConsumerTab.delivery:
        return Icons.local_shipping;
      case ConsumerTab.profile:
        return Icons.person;
    }
  }

  /// Icône Cupertino pour l'onglet (iOS)
  IconData get cupertinoIcon {
    switch (this) {
      case ConsumerTab.discover:
        return CupertinoIcons.house;
      case ConsumerTab.browse:
        return CupertinoIcons.search;
      case ConsumerTab.favorites:
        return CupertinoIcons.heart;
      case ConsumerTab.cart:
        return CupertinoIcons.cart;
      case ConsumerTab.delivery:
        return CupertinoIcons.car;
      case ConsumerTab.profile:
        return CupertinoIcons.person;
    }
  }

  /// Icône Cupertino sélectionnée pour l'onglet (iOS)
  IconData get cupertinoActiveIcon {
    switch (this) {
      case ConsumerTab.discover:
        return CupertinoIcons.house_fill;
      case ConsumerTab.browse:
        return CupertinoIcons.search;
      case ConsumerTab.favorites:
        return CupertinoIcons.heart_fill;
      case ConsumerTab.cart:
        return CupertinoIcons.cart_fill;
      case ConsumerTab.delivery:
        return CupertinoIcons.car_fill;
      case ConsumerTab.profile:
        return CupertinoIcons.person_solid;
    }
  }

  /// Route associée à l'onglet
  String get route {
    switch (this) {
      case ConsumerTab.discover:
        return '/consumer/discover';
      case ConsumerTab.browse:
        return '/consumer/browse';
      case ConsumerTab.favorites:
        return '/consumer/favorites';
      case ConsumerTab.cart:
        return '/consumer/cart';
      case ConsumerTab.delivery:
        return '/consumer/delivery';
      case ConsumerTab.profile:
        return '/consumer/profile';
    }
  }

  /// Obtenir l'onglet à partir d'un index
  static ConsumerTab fromIndex(int index) {
    return ConsumerTab.values[index.clamp(0, ConsumerTab.values.length - 1)];
  }

  /// Obtenir l'onglet à partir d'une route
  static ConsumerTab? fromRoute(String route) {
    for (final tab in ConsumerTab.values) {
      if (route.startsWith(tab.route)) {
        return tab;
      }
    }
    return null;
  }
}
