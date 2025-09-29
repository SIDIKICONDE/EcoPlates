import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/consumer_tabs.dart';
import '../../core/constants/merchant_tabs.dart';

/// Shell unifié qui affiche un NavigationBar dynamique selon le contexte
/// - Si la route commence par /consumer, on affiche les onglets consumer
/// - Si la route commence par /merchant, on affiche les onglets merchant
/// - Sinon, on n'affiche pas de barre (welcome, pages publiques)
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  bool _isConsumer(String location) => location.startsWith('/consumer');
  bool _isMerchant(String location) => location.startsWith('/merchant');

  int _consumerIndexFromRoute(String location) {
    return (ConsumerTab.fromRoute(location) ?? ConsumerTab.discover).index;
  }

  int _merchantIndexFromRoute(String location) {
    return (MerchantTab.fromRoute(location) ?? MerchantTab.dashboard).index;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    // Pas de barre pour pages publiques (welcome, etc.)
    if (!_isConsumer(location) && !_isMerchant(location)) {
      return child;
    }

    if (_isConsumer(location)) {
      final selectedIndex = _consumerIndexFromRoute(location);
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            final tab = ConsumerTab.values[index];
            context.go(tab.route);
          },
          destinations: ConsumerTab.values.map((tab) {
            return NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.activeIcon),
              label: tab.shortLabel,
            );
          }).toList(),
        ),
      );
    }

    // Merchant
    final selectedIndex = _merchantIndexFromRoute(location);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          final tab = MerchantTab.values[index];
          context.go(tab.route);
        },
        destinations: MerchantTab.values.map((tab) {
          return NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.activeIcon),
            label: tab.shortLabel,
          );
        }).toList(),
      ),
    );
  }
}
