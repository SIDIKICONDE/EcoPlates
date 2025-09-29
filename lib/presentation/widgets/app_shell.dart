import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/consumer_tabs.dart';
import '../../core/constants/merchant_tabs.dart';
import '../../core/responsive/responsive_utils.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Breakpoints simplifiés :
    // Mobile: < 768px - Navigation bar en bas
    // Desktop/Tablette paysage: >= 768px - Sidebar latérale
    
    final isDesktop = screenWidth >= 768;

    // Pas de barre pour pages publiques (welcome, etc.)
    if (!_isConsumer(location) && !_isMerchant(location)) {
      return child;
    }

    if (_isConsumer(location)) {
      final selectedIndex = _consumerIndexFromRoute(location);
      
      // Utiliser sidebar pour desktop/tablette paysage
      if (isDesktop) {
        return Scaffold(
          body: Row(
            children: [
              _buildConsumerSidebar(context, selectedIndex, screenWidth),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 24),
                  child: child,
                ),
              ),
            ],
          ),
        );
      }
      
      // Pour mobile/tablette portrait, utiliser la navigation bar
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
    
      // Utiliser sidebar pour desktop/tablette paysage
      if (isDesktop) {
        return Scaffold(
          body: Row(
            children: [
              _buildMerchantSidebar(context, selectedIndex, screenWidth),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 24),
                  child: child,
                ),
              ),
            ],
          ),
        );
      }
    
    // Pour mobile/tablette portrait, utiliser la navigation bar
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
  
  Widget _buildConsumerSidebar(BuildContext context, int selectedIndex, double screenWidth) {
    // Largeur fixe de la sidebar
    const sidebarWidth = 250.0;
    
    return Container(
      width: sidebarWidth,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(
                  Icons.eco,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'EcoPlates',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: ConsumerTab.values.map((tab) {
                final isSelected = selectedIndex == tab.index;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Material(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => context.go(tab.route),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? tab.activeIcon : tab.icon,
                              size: 24,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                tab.label,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMerchantSidebar(BuildContext context, int selectedIndex, double screenWidth) {
    // Largeur fixe de la sidebar
    const sidebarWidth = 250.0;
    
    return Container(
      width: sidebarWidth,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EcoPlates',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Merchant',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: MerchantTab.values.map((tab) {
                final isSelected = selectedIndex == tab.index;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Material(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => context.go(tab.route),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? tab.activeIcon : tab.icon,
                              size: 24,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                tab.label,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
