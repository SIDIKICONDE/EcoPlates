import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/merchant_tabs.dart';
import '../../core/widgets/adaptive_widgets.dart';
import '../providers/merchant_tab_provider.dart';

/// Barre de navigation adaptative pour l'interface marchand
class MerchantTabBar extends ConsumerWidget {
  const MerchantTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(merchantTabProvider);

    if (PlatformUtils.shouldUseCupertino) {
      return _buildCupertinoTabBar(context, ref, currentTab);
    } else {
      return _buildMaterialTabBar(context, ref, currentTab);
    }
  }

  /// Construction de la barre d'onglets iOS (Cupertino)
  Widget _buildCupertinoTabBar(
    BuildContext context,
    WidgetRef ref,
    MerchantTab currentTab,
  ) {
    return CupertinoTabBar(
      currentIndex: currentTab.index,
      onTap: (index) => _onTabTapped(context, ref, index),
      items: MerchantTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.cupertinoIcon),
          activeIcon: Icon(tab.cupertinoActiveIcon),
          label: tab.shortLabel,
        );
      }).toList(),
    );
  }

  /// Construction de la barre de navigation Material 3
  Widget _buildMaterialTabBar(
    BuildContext context,
    WidgetRef ref,
    MerchantTab currentTab,
  ) {
    return NavigationBar(
      selectedIndex: currentTab.index,
      onDestinationSelected: (index) => _onTabTapped(context, ref, index),
      destinations: MerchantTab.values.map((tab) {
        return NavigationDestination(
          icon: Badge(
            isLabelVisible: _shouldShowBadge(tab),
            label: Text(_getBadgeCount(tab)),
            child: Icon(tab.icon),
          ),
          selectedIcon: Badge(
            isLabelVisible: _shouldShowBadge(tab),
            label: Text(_getBadgeCount(tab)),
            child: Icon(tab.activeIcon),
          ),
          label: tab.shortLabel,
          tooltip: tab.label,
        );
      }).toList(),
    );
  }

  /// Gestion du tap sur un onglet
  void _onTabTapped(BuildContext context, WidgetRef ref, int index) {
    final selectedTab = MerchantTab.fromIndex(index);
    
    // Mise à jour du provider
    ref.read(merchantTabProvider.notifier).state = selectedTab;
    
    // Navigation vers la route correspondante
    context.go(selectedTab.route);
  }

  /// Détermine si un badge doit être affiché pour un onglet
  bool _shouldShowBadge(MerchantTab tab) {
    // TODO: Implémenter la logique pour afficher les badges
    // Par exemple : nouvelles commandes, stock faible, etc.
    switch (tab) {
      case MerchantTab.stock:
        return false; // Retourner true si stock faible
      case MerchantTab.sales:
        return false; // Retourner true si nouvelles ventes
      default:
        return false;
    }
  }

  /// Obtient le nombre à afficher dans le badge
  String _getBadgeCount(MerchantTab tab) {
    // TODO: Implémenter la logique pour obtenir le compte
    switch (tab) {
      case MerchantTab.stock:
        return '2'; // Nombre d'articles en rupture
      case MerchantTab.sales:
        return '5'; // Nombre de nouvelles ventes
      default:
        return '';
    }
  }
}

/// Version avec emoji dans les labels (optionnelle)
class MerchantTabBarWithEmoji extends ConsumerWidget {
  final bool showLabels;
  
  const MerchantTabBarWithEmoji({
    super.key,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(merchantTabProvider);

    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoTabBar(
        currentIndex: currentTab.index,
        onTap: (index) => _onTabTapped(context, ref, index),
        items: MerchantTab.values.map((tab) {
          final label = showLabels 
              ? '${tab.emoji} ${tab.shortLabel}' 
              : tab.emoji;
          return BottomNavigationBarItem(
            icon: Text(tab.emoji, style: const TextStyle(fontSize: 24)),
            label: label,
          );
        }).toList(),
      );
    } else {
      return NavigationBar(
        selectedIndex: currentTab.index,
        onDestinationSelected: (index) => _onTabTapped(context, ref, index),
        labelBehavior: showLabels 
            ? NavigationDestinationLabelBehavior.alwaysShow
            : NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: MerchantTab.values.map((tab) {
          return NavigationDestination(
            icon: Text(tab.emoji, style: const TextStyle(fontSize: 24)),
            selectedIcon: Text(tab.emoji, style: const TextStyle(fontSize: 28)),
            label: tab.shortLabel,
            tooltip: tab.label,
          );
        }).toList(),
      );
    }
  }

  void _onTabTapped(BuildContext context, WidgetRef ref, int index) {
    final selectedTab = MerchantTab.fromIndex(index);
    ref.read(merchantTabProvider.notifier).state = selectedTab;
    context.go(selectedTab.route);
  }
}