import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Énumération des onglets disponibles pour l'interface marchand
enum MerchantTab {
  dashboard,
  stock,
  store,
  sales,
  analytics;

  /// Label localisé de l'onglet
  String get label {
    switch (this) {
      case MerchantTab.dashboard:
        return 'Tableau de bord';
      case MerchantTab.stock:
        return 'Stock';
      case MerchantTab.store:
        return 'Boutique';
      case MerchantTab.sales:
        return 'Ventes';
      case MerchantTab.analytics:
        return 'Analytics';
    }
  }

  /// Label court pour affichage mobile
  String get shortLabel {
    switch (this) {
      case MerchantTab.dashboard:
        return 'Tableau';
      case MerchantTab.stock:
        return 'Stock';
      case MerchantTab.store:
        return 'Boutique';
      case MerchantTab.sales:
        return 'Ventes';
      case MerchantTab.analytics:
        return 'Analyse';
    }
  }

  /// Emoji associé à l'onglet
  String get emoji {
    switch (this) {
      case MerchantTab.dashboard:
        return '📊';
      case MerchantTab.stock:
        return '📦';
      case MerchantTab.store:
        return '🏬';
      case MerchantTab.sales:
        return '💰';
      case MerchantTab.analytics:
        return '📈';
    }
  }

  /// Icône Material pour l'onglet
  IconData get icon {
    switch (this) {
      case MerchantTab.dashboard:
        return Icons.dashboard_outlined;
      case MerchantTab.stock:
        return Icons.inventory_2_outlined;
      case MerchantTab.store:
        return Icons.storefront_outlined;
      case MerchantTab.sales:
        return Icons.point_of_sale_outlined;
      case MerchantTab.analytics:
        return Icons.analytics_outlined;
    }
  }

  /// Icône Material sélectionnée pour l'onglet
  IconData get activeIcon {
    switch (this) {
      case MerchantTab.dashboard:
        return Icons.dashboard;
      case MerchantTab.stock:
        return Icons.inventory_2;
      case MerchantTab.store:
        return Icons.storefront;
      case MerchantTab.sales:
        return Icons.point_of_sale;
      case MerchantTab.analytics:
        return Icons.analytics;
    }
  }

  /// Icône Cupertino pour l'onglet (iOS)
  IconData get cupertinoIcon {
    switch (this) {
      case MerchantTab.dashboard:
        return CupertinoIcons.chart_bar_square;
      case MerchantTab.stock:
        return CupertinoIcons.cube_box;
      case MerchantTab.store:
        return CupertinoIcons.bag;
      case MerchantTab.sales:
        return CupertinoIcons.money_dollar;
      case MerchantTab.analytics:
        return CupertinoIcons.chart_pie;
    }
  }

  /// Icône Cupertino sélectionnée pour l'onglet (iOS)
  IconData get cupertinoActiveIcon {
    switch (this) {
      case MerchantTab.dashboard:
        return CupertinoIcons.chart_bar_square_fill;
      case MerchantTab.stock:
        return CupertinoIcons.cube_box_fill;
      case MerchantTab.store:
        return CupertinoIcons.bag_fill;
      case MerchantTab.sales:
        return CupertinoIcons.money_dollar_circle_fill;
      case MerchantTab.analytics:
        return CupertinoIcons.chart_pie_fill;
    }
  }

  /// Route associée à l'onglet
  String get route {
    switch (this) {
      case MerchantTab.dashboard:
        return '/merchant/dashboard';
      case MerchantTab.stock:
        return '/merchant/stock';
      case MerchantTab.store:
        return '/merchant/store';
      case MerchantTab.sales:
        return '/merchant/sales';
      case MerchantTab.analytics:
        return '/merchant/analytics';
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
