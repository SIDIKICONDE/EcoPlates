import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../pages/browse_page.dart';
import '../../pages/consumer_profile_page.dart';
import '../../screens/main_home_screen.dart';
import '../../screens/all_urgent_offers_screen.dart';

/// Menu tablette intégré avec les vraies pages de l'application
class IntegratedTabletMenu extends ConsumerStatefulWidget {
  const IntegratedTabletMenu({super.key});

  @override
  ConsumerState<IntegratedTabletMenu> createState() => _IntegratedTabletMenuState();
}

class _IntegratedTabletMenuState extends ConsumerState<IntegratedTabletMenu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // Pages réelles de l'application
  final List<Widget> _pages = const [
    MainHomeScreen(),
    BrowsePage(),
    AllUrgentOffersScreen(),
    _FavoritesPlaceholder(), // À remplacer par votre page de favoris
    ConsumerProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Adapter la largeur de la sidebar selon la taille de l'écran
    final sidebarWidth = screenWidth > 1200 ? 280.0 : 240.0;

    return Scaffold(
      body: isLandscape
          ? _buildLandscapeLayout(sidebarWidth)
          : _buildPortraitLayout(),
    );
  }

  Widget _buildLandscapeLayout(double sidebarWidth) {
    return Row(
      children: [
        // Sidebar navigation
        _buildSidebar(sidebarWidth),
        // Divider
        const VerticalDivider(width: 1, thickness: 1),
        // Content area
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(), // Désactiver le swipe
            children: _pages,
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        // Content area
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _pages,
          ),
        ),
        // Bottom navigation
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildSidebar(double width) {
    return Container(
      width: width,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Logo header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.eco,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EcoPlates',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Tablette',
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
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _NavigationTile(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Accueil',
                  isSelected: _currentIndex == 0,
                  onTap: () => _tabController.animateTo(0),
                ),
                _NavigationTile(
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                  label: 'Explorer',
                  isSelected: _currentIndex == 1,
                  onTap: () => _tabController.animateTo(1),
                ),
                _NavigationTile(
                  icon: Icons.local_fire_department_outlined,
                  selectedIcon: Icons.local_fire_department,
                  label: 'Offres Urgentes',
                  isSelected: _currentIndex == 2,
                  onTap: () => _tabController.animateTo(2),
                  badge: '5',
                ),
                _NavigationTile(
                  icon: Icons.favorite_border,
                  selectedIcon: Icons.favorite,
                  label: 'Favoris',
                  isSelected: _currentIndex == 3,
                  onTap: () => _tabController.animateTo(3),
                ),
                _NavigationTile(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Profil',
                  isSelected: _currentIndex == 4,
                  onTap: () => _tabController.animateTo(4),
                ),
              ],
            ),
          ),
          // Settings section
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Paramètres'),
            onTap: () {
              // Navigation vers paramètres
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Accueil',
                isSelected: _currentIndex == 0,
                onTap: () => _tabController.animateTo(0),
              ),
              _BottomNavItem(
                icon: Icons.explore_outlined,
                selectedIcon: Icons.explore,
                label: 'Explorer',
                isSelected: _currentIndex == 1,
                onTap: () => _tabController.animateTo(1),
              ),
              _BottomNavItem(
                icon: Icons.local_fire_department_outlined,
                selectedIcon: Icons.local_fire_department,
                label: 'Urgentes',
                isSelected: _currentIndex == 2,
                onTap: () => _tabController.animateTo(2),
                badge: '5',
              ),
              _BottomNavItem(
                icon: Icons.favorite_border,
                selectedIcon: Icons.favorite,
                label: 'Favoris',
                isSelected: _currentIndex == 3,
                onTap: () => _tabController.animateTo(3),
              ),
              _BottomNavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profil',
                isSelected: _currentIndex == 4,
                onTap: () => _tabController.animateTo(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tuile de navigation pour la sidebar
class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      isSelected ? selectedIcon : icon,
                      size: 24,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    if (badge != null)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Item de navigation pour la barre inférieure
class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
                    size: 26,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder pour la page des favoris
class _FavoritesPlaceholder extends StatelessWidget {
  const _FavoritesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Vos offres favorites',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Retrouvez ici toutes vos offres sauvegardées',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
