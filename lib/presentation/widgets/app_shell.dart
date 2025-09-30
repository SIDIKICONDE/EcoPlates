import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/consumer_tabs.dart';
import '../../core/constants/merchant_tabs.dart';
import '../providers/app_mode_provider.dart';

/// Shell unifié qui affiche un NavigationBar dynamique selon le contexte
/// - Si la route commence par /consumer, on affiche les onglets consumer
/// - Si la route commence par /merchant, on affiche les onglets merchant
/// - Sinon, on n'affiche pas de barre (welcome, pages publiques)
class AppShell extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
              _buildMerchantSidebar(context, ref, selectedIndex, screenWidth),
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
  
  Widget _buildMerchantSidebar(BuildContext context, WidgetRef ref, int selectedIndex, double screenWidth) {
    // Largeur fixe de la sidebar
    const sidebarWidth = 250.0;
    
    // Pour l'instant, utiliser des données mockées
    // TODO: Remplacer par les vraies données du marchand
    const merchantName = 'Boulangerie Paul';
    const merchantLogoUrl = 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400';
    
    return Container(
      width: sidebarWidth,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Logo du marchand
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: merchantLogoUrl.isNotEmpty
                        ? Image.network(
                            merchantLogoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => ColoredBox(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              child: Icon(
                                Icons.store,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : ColoredBox(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.store,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Nom du marchand
                Text(
                  merchantName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Espace Marchand',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
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
