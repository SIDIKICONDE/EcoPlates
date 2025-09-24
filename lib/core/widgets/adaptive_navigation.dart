import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'adaptive_widgets.dart';

/// Navigation adaptative qui utilise CupertinoTabBar sur iOS/macOS
/// et BottomNavigationBar sur les autres plateformes
class AdaptiveBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<AdaptiveNavItem> items;

  const AdaptiveBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/reservations');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      // iOS/macOS: Utiliser CupertinoTabBar
      return CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon ?? item.icon),
            label: item.label,
          );
        }).toList(),
      );
    } else {
      // Autres plateformes: Utiliser BottomNavigationBar Material
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon ?? item.icon),
            label: item.label,
          );
        }).toList(),
      );
    }
  }
}

/// Item de navigation adaptatif
class AdaptiveNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const AdaptiveNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Scaffold avec navigation adaptative intégrée
class AdaptiveNavigationScaffold extends StatelessWidget {
  final Widget child;

  const AdaptiveNavigationScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location.startsWith('/reservations')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    if (PlatformUtils.shouldUseCupertino) {
      // iOS/macOS: Utiliser CupertinoTabScaffold
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/reservations');
                break;
              case 2:
                context.go('/profile');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: 'Réservations',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profil',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return child;
        },
      );
    } else {
      // Autres plateformes: Utiliser Scaffold avec BottomNavigationBar
      return Scaffold(
        body: child,
        bottomNavigationBar: AdaptiveBottomNavigation(
          currentIndex: currentIndex,
          items: const [
            AdaptiveNavItem(icon: Icons.home, label: 'Accueil'),
            AdaptiveNavItem(icon: Icons.calendar_today, label: 'Réservations'),
            AdaptiveNavItem(icon: Icons.person, label: 'Profil'),
          ],
        ),
      );
    }
  }
}
