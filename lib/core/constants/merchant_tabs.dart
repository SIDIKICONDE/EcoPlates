import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Énumération des onglets disponibles pour l'interface marchand
enum MerchantTab {
  dashboard,
  stock,
  sales,
  analytics,
  home;

  /// Label localisé de l'onglet
  String get label {
    switch (this) {
      case MerchantTab.dashboard:
        return 'Tableau de bord';
      case MerchantTab.stock:
        return 'Stock';
      case MerchantTab.sales:
        return 'Ventes';
      case MerchantTab.analytics:
        return 'Analytics';
      case MerchantTab.home:
        return 'Accueil';
    }
  }

  /// Label court pour affichage mobile
  String get shortLabel {
    switch (this) {
      case MerchantTab.dashboard:
        return 'Tableau';
      case MerchantTab.stock:
        return 'Stock';
      case MerchantTab.sales:
        return 'Ventes';
      case MerchantTab.analytics:
        return 'Analyse';
      case MerchantTab.home:
        return 'Accueil';
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
      case MerchantTab.analytics:
        return '📈';
      case MerchantTab.home:
        return '🏠';
    }
  }

  /// Icône Material pour l'onglet
  IconData get icon {
    switch (this) {
      case MerchantTab.dashboard:
        return Icons.dashboard_outlined;
      case MerchantTab.stock:
        return Icons.inventory_2_outlined;
      case MerchantTab.sales:
        return Icons.point_of_sale_outlined;
      case MerchantTab.analytics:
        return Icons.analytics_outlined;
      case MerchantTab.home:
        return Icons.home_outlined;
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
      case MerchantTab.analytics:
        return Icons.analytics;
      case MerchantTab.home:
        return Icons.home;
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
        return CupertinoIcons.money_dollar;
      case MerchantTab.analytics:
        return CupertinoIcons.chart_pie;
      case MerchantTab.home:
        return CupertinoIcons.home;
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
      case MerchantTab.analytics:
        return CupertinoIcons.chart_pie_fill;
      case MerchantTab.home:
        return CupertinoIcons.house_fill;
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
      case MerchantTab.analytics:
        return '/merchant/analytics';
      case MerchantTab.home:
        return '/merchant/home';
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
