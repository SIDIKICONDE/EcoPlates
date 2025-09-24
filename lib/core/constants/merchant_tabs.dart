import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Enumération des onglets disponibles pour l'interface marchand
enum MerchantTab {
  dashboard,
  stock,
  sales,
  store,
  analytics,
  profile;

  /// Label localisé de l'onglet
  String get label {
    switch (this) {
      case MerchantTab.dashboard:
        return 'Tableau de bord';
      case MerchantTab.stock:
        return 'Stock';
      case MerchantTab.sales:
        return 'Ventes';
      case MerchantTab.store:
        return 'Boutique';
      case MerchantTab.analytics:
        return 'Analytics';
      case MerchantTab.profile:
        return 'Profil';
    }
  }

  /// Label court pour affichage mobile
  String get shortLabel {
    switch (this) {
      case MerchantTab.dashboard:
        return 'Dashboard';
      case MerchantTab.stock:
        return 'Stock';
      case MerchantTab.sales:
        return 'Ventes';
      case MerchantTab.store:
        return 'Store';
      case MerchantTab.analytics:
        return 'Analytics';
      case MerchantTab.profile:
        return 'Profil';
    }
  }

  /// Emoji associé à l'onglet
  String get emoji {
    switch (this) {
      case MerchantTab.dashboard:
        return '📊';
      case MerchantTab.stock:
        return '📦';
      case MerchantTab.sales:
        return '💰';
      case MerchantTab.store:
        return '🏪';
      case MerchantTab.analytics:
        return '📈';
      case MerchantTab.profile:
        return '⚙️';
    }
  }

  /// Icône Material pour l'onglet
  IconData get icon {
    switch (this) {
      case MerchantTab.dashboard:
        return Icons.dashboard;
      case MerchantTab.stock:
        return Icons.inventory_2;
      case MerchantTab.sales:
        return Icons.point_of_sale;
      case MerchantTab.store:
        return Icons.store;
      case MerchantTab.analytics:
        return Icons.analytics;
      case MerchantTab.profile:
        return Icons.settings;
    }
  }

  /// Icône Material sélectionnée pour l'onglet
  IconData get activeIcon {
    switch (this) {
      case MerchantTab.dashboard:
        return Icons.dashboard;
      case MerchantTab.stock:
        return Icons.inventory_2;
      case MerchantTab.sales:
        return Icons.point_of_sale;
      case MerchantTab.store:
        return Icons.store;
      case MerchantTab.analytics:
        return Icons.analytics;
      case MerchantTab.profile:
        return Icons.settings;
    }
  }

  /// Icône Cupertino pour l'onglet (iOS)
  IconData get cupertinoIcon {
    switch (this) {
      case MerchantTab.dashboard:
        return CupertinoIcons.chart_bar_square;
      case MerchantTab.stock:
        return CupertinoIcons.cube_box;
      case MerchantTab.sales:
        return CupertinoIcons.money_dollar_circle;
      case MerchantTab.store:
        return CupertinoIcons.shopping_cart;
      case MerchantTab.analytics:
        return CupertinoIcons.chart_bar_alt_fill;
      case MerchantTab.profile:
        return CupertinoIcons.gear;
    }
  }

  /// Icône Cupertino sélectionnée pour l'onglet (iOS)
  IconData get cupertinoActiveIcon {
    switch (this) {
      case MerchantTab.dashboard:
        return CupertinoIcons.chart_bar_square_fill;
      case MerchantTab.stock:
        return CupertinoIcons.cube_box_fill;
      case MerchantTab.sales:
        return CupertinoIcons.money_dollar_circle_fill;
      case MerchantTab.store:
        return CupertinoIcons.cart_fill;
      case MerchantTab.analytics:
        return CupertinoIcons.chart_bar_alt_fill;
      case MerchantTab.profile:
        return CupertinoIcons.gear_solid;
    }
  }

  /// Route associée à l'onglet
  String get route {
    switch (this) {
      case MerchantTab.dashboard:
        return '/merchant/dashboard';
      case MerchantTab.stock:
        return '/merchant/stock';
      case MerchantTab.sales:
        return '/merchant/sales';
      case MerchantTab.store:
        return '/merchant/store';
      case MerchantTab.analytics:
        return '/merchant/analytics';
      case MerchantTab.profile:
        return '/merchant/profile';
    }
  }

  /// Obtenir l'onglet à partir d'un index
  static MerchantTab fromIndex(int index) {
    return MerchantTab.values[index.clamp(0, MerchantTab.values.length - 1)];
  }

  /// Obtenir l'onglet à partir d'une route
  static MerchantTab? fromRoute(String route) {
    for (final tab in MerchantTab.values) {
      if (route.startsWith(tab.route)) {
        return tab;
      }
    }
    return null;
  }
}