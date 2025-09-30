import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Menu avec tabs optimisé pour tablettes
class TabletTabMenu extends ConsumerStatefulWidget {
  const TabletTabMenu({super.key});

  @override
  ConsumerState<TabletTabMenu> createState() => _TabletTabMenuState();
}

class _TabletTabMenuState extends ConsumerState<TabletTabMenu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
    final isTablet = ResponsiveUtils.isTablet(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Si ce n'est pas une tablette, retourner un widget vide
    if (!isTablet) {
      return const SizedBox.shrink();
    }

    return isLandscape
        ? _buildLandscapeTabMenu(context)
        : _buildPortraitTabMenu(context);
  }

  /// Menu en mode paysage (sidebar)
  Widget _buildLandscapeTabMenu(BuildContext context) {
    return Row(
      children: [
        // Sidebar avec navigation
        Container(
          width: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                DeepColorTokens.surface,
                DeepColorTokens.surfaceContainer,
              ],
            ),
            border: Border(
              right: BorderSide(
                color: DeepColorTokens.neutral0.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: DeepColorTokens.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.eco,
                        size: 28,
                        color: DeepColorTokens.neutral0,
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
                            color: DeepColorTokens.neutral0,
                          ),
                        ),
                        Text(
                          'Tablette',
                          style: TextStyle(
                            fontSize: 12,
                            color: DeepColorTokens.neutral0.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildSidebarItem(
                      context,
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home,
                      label: 'Accueil',
                      index: 0,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.explore_outlined,
                      selectedIcon: Icons.explore,
                      label: 'Explorer',
                      index: 1,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.local_fire_department_outlined,
                      selectedIcon: Icons.local_fire_department,
                      label: 'Urgences',
                      index: 2,
                      badge: '3',
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.favorite_border,
                      selectedIcon: Icons.favorite,
                      label: 'Favoris',
                      index: 3,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.person_outline,
                      selectedIcon: Icons.person,
                      label: 'Profil',
                      index: 4,
                    ),
                  ],
                ),
              ),
              // Bottom section
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.settings_outlined,
                        color: DeepColorTokens.neutral0.withValues(alpha: 0.7),
                      ),
                      title: Text(
                        'Paramètres',
                        style: TextStyle(
                          color: DeepColorTokens.neutral0,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        // Navigation vers paramètres
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Content area
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildContentPlaceholder('Accueil'),
              _buildContentPlaceholder('Explorer'),
              _buildContentPlaceholder('Offres Urgentes'),
              _buildContentPlaceholder('Favoris'),
              _buildContentPlaceholder('Profil'),
            ],
          ),
        ),
      ],
    );
  }

  /// Menu en mode portrait (bottom tabs améliorés)
  Widget _buildPortraitTabMenu(BuildContext context) {
    return Column(
      children: [
        // Content area
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildContentPlaceholder('Accueil'),
              _buildContentPlaceholder('Explorer'),
              _buildContentPlaceholder('Offres Urgentes'),
              _buildContentPlaceholder('Favoris'),
              _buildContentPlaceholder('Profil'),
            ],
          ),
        ),
        // Enhanced bottom navigation for tablets
        Container(
          decoration: BoxDecoration(
            color: DeepColorTokens.surface,
            boxShadow: [
              BoxShadow(
                color: DeepColorTokens.neutral0.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 80, // Plus haut pour les tablettes
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(
                    context,
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Accueil',
                    index: 0,
                  ),
                  _buildTabItem(
                    context,
                    icon: Icons.explore_outlined,
                    selectedIcon: Icons.explore,
                    label: 'Explorer',
                    index: 1,
                  ),
                  _buildTabItem(
                    context,
                    icon: Icons.local_fire_department_outlined,
                    selectedIcon: Icons.local_fire_department,
                    label: 'Urgences',
                    index: 2,
                    badge: '3',
                  ),
                  _buildTabItem(
                    context,
                    icon: Icons.favorite_border,
                    selectedIcon: Icons.favorite,
                    label: 'Favoris',
                    index: 3,
                  ),
                  _buildTabItem(
                    context,
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Profil',
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Item de sidebar pour mode paysage
  Widget _buildSidebarItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    String? badge,
  }) {
    final isSelected = _currentIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? DeepColorTokens.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            _tabController.animateTo(index);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Icon(
                      isSelected ? selectedIcon : icon,
                      size: 24,
                      color: isSelected
                          ? DeepColorTokens.primary
                          : DeepColorTokens.neutral0.withValues(alpha: 0.7),
                    ),
                    if (badge != null)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: DeepColorTokens.urgent,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            badge,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? DeepColorTokens.primary
                          : DeepColorTokens.neutral0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Item de tab pour mode portrait
  Widget _buildTabItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    String? badge,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
                    size: 28, // Plus grand pour les tablettes
                    color: isSelected
                        ? DeepColorTokens.primary
                        : DeepColorTokens.neutral0.withValues(alpha: 0.6),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: DeepColorTokens.urgent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          badge,
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
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? DeepColorTokens.primary
                      : DeepColorTokens.neutral0.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Placeholder pour le contenu (à remplacer par vos pages)
  Widget _buildContentPlaceholder(String title) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            DeepColorTokens.surface,
            DeepColorTokens.surfaceContainer,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: DeepColorTokens.confidenceGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.tablet,
                size: 60,
                color: DeepColorTokens.neutral0,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: DeepColorTokens.neutral0,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Interface optimisée pour tablettes',
                style: TextStyle(
                  fontSize: 16,
                  color: DeepColorTokens.neutral0.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
