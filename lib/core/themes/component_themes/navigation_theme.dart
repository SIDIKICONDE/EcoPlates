import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/color_tokens.dart';
import '../tokens/elevation_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/spacing_tokens.dart';
import '../tokens/typography_tokens.dart';

/// Thème de navigation pour EcoPlates
class EcoNavigationTheme {
  EcoNavigationTheme._();

  // ===== APP BAR THEME =====
  static AppBarTheme appBarTheme({required bool isDark}) {
    return AppBarTheme(
      // Couleurs
      backgroundColor: isDark
          ? EcoColorTokens.neutral900
          : EcoColorTokens.neutral0,
      foregroundColor: isDark
          ? EcoColorTokens.neutral100
          : EcoColorTokens.neutral800,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black12,

      // Élévation
      elevation: EcoElevation.appBarElevation,
      scrolledUnderElevation: EcoElevation.level2,

      // Style du titre
      titleTextStyle: EcoTypography.headlineSmallLight.copyWith(
        color: isDark ? EcoColorTokens.neutral100 : EcoColorTokens.neutral800,
        fontWeight: EcoTypography.semiBold,
      ),

      // Position du titre
      centerTitle: true,

      // Hauteur
      toolbarHeight: 64,

      // Système de status bar
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,

      // Style des icônes
      iconTheme: IconThemeData(
        color: isDark ? EcoColorTokens.neutral200 : EcoColorTokens.neutral700,
        size: 24,
      ),

      // Style des actions
      actionsIconTheme: IconThemeData(
        color: isDark ? EcoColorTokens.neutral200 : EcoColorTokens.neutral700,
        size: 24,
      ),

      // Forme
      shape: const Border(
        bottom: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
    );
  }

  // ===== BOTTOM NAVIGATION BAR THEME =====
  static BottomNavigationBarThemeData bottomNavigationBarTheme({
    required bool isDark,
  }) {
    return BottomNavigationBarThemeData(
      // Type
      type: BottomNavigationBarType.fixed,

      // Couleurs
      backgroundColor: isDark
          ? EcoColorTokens.neutral900
          : EcoColorTokens.neutral0,
      selectedItemColor: EcoColorTokens.primary,
      unselectedItemColor: isDark
          ? EcoColorTokens.neutral500
          : EcoColorTokens.neutral400,

      // Styles de texte
      selectedLabelStyle: EcoTypography.labelSmallLight.copyWith(
        color: EcoColorTokens.primary,
        fontWeight: EcoTypography.semiBold,
      ),
      unselectedLabelStyle: EcoTypography.labelSmallLight.copyWith(
        color: isDark ? EcoColorTokens.neutral500 : EcoColorTokens.neutral400,
      ),

      // Élévation
      elevation: EcoElevation.navBarElevation,

      // Taille des icônes
      selectedIconTheme: const IconThemeData(
        size: 24,
        color: EcoColorTokens.primary,
      ),
      unselectedIconTheme: IconThemeData(
        size: 22,
        color: isDark ? EcoColorTokens.neutral500 : EcoColorTokens.neutral400,
      ),

      // Animation
      enableFeedback: true,
    );
  }

  // ===== NAVIGATION RAIL THEME =====
  static NavigationRailThemeData navigationRailTheme({required bool isDark}) {
    return NavigationRailThemeData(
      // Couleurs
      backgroundColor: isDark
          ? EcoColorTokens.neutral900
          : EcoColorTokens.neutral50,
      selectedIconTheme: const IconThemeData(
        size: 24,
        color: EcoColorTokens.primary,
      ),
      unselectedIconTheme: IconThemeData(
        size: 22,
        color: isDark ? EcoColorTokens.neutral500 : EcoColorTokens.neutral400,
      ),
      selectedLabelTextStyle: EcoTypography.labelMediumLight.copyWith(
        color: EcoColorTokens.primary,
        fontWeight: EcoTypography.semiBold,
      ),
      unselectedLabelTextStyle: EcoTypography.labelMediumLight.copyWith(
        color: isDark ? EcoColorTokens.neutral500 : EcoColorTokens.neutral400,
      ),

      // Élévation
      elevation: EcoElevation.level1,

      // Largeur
      minWidth: 80,
      minExtendedWidth: 200,
    );
  }

  // ===== DRAWER THEME =====
  static DrawerThemeData drawerTheme({required bool isDark}) {
    return DrawerThemeData(
      // Couleurs
      backgroundColor: isDark
          ? EcoColorTokens.neutral900
          : EcoColorTokens.neutral0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black26,

      // Élévation
      elevation: EcoElevation.drawerElevation,

      // Forme
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(EcoRadius.lg),
          bottomRight: Radius.circular(EcoRadius.lg),
        ),
      ),

      // Largeur
      width: 280,
    );
  }

  // ===== TAB BAR THEME =====
  static TabBarThemeData tabBarTheme({required bool isDark}) {
    return TabBarThemeData(
      // Couleurs
      labelColor: EcoColorTokens.primary,
      unselectedLabelColor: isDark
          ? EcoColorTokens.neutral400
          : EcoColorTokens.neutral500,
      indicatorColor: EcoColorTokens.primary,
      dividerColor: isDark
          ? EcoColorTokens.neutral700
          : EcoColorTokens.neutral200,

      // Styles de texte
      labelStyle: EcoTypography.labelLargeLight.copyWith(
        color: EcoColorTokens.primary,
        fontWeight: EcoTypography.semiBold,
      ),
      unselectedLabelStyle: EcoTypography.labelLargeLight.copyWith(
        color: isDark ? EcoColorTokens.neutral400 : EcoColorTokens.neutral500,
      ),

      // Padding
      labelPadding: EcoSpacing.asymmetric(horizontal: EcoSpacing.lg),

      // Indicateur
      indicatorSize: TabBarIndicatorSize.tab,

      // Propriétés de l'onglet
      tabAlignment: TabAlignment.center,
    );
  }

  // ===== WIDGETS DE NAVIGATION PERSONNALISÉS =====

  /// AppBar EcoPlates avec style unifié
  static PreferredSizeWidget ecoAppBar({
    String? title,
    List<Widget>? actions,
    Widget? leading,
    PreferredSizeWidget? bottom,
    bool automaticallyImplyLeading = true,
    bool isDark = false,
  }) {
    return AppBar(
      title: title != null
          ? Text(
              title,
              style: EcoTypography.headlineSmallLight.copyWith(
                color: isDark
                    ? EcoColorTokens.neutral100
                    : EcoColorTokens.neutral800,
                fontWeight: EcoTypography.semiBold,
              ),
            )
          : null,
      actions: actions,
      leading: leading,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: isDark
          ? EcoColorTokens.neutral900
          : EcoColorTokens.neutral0,
      foregroundColor: isDark
          ? EcoColorTokens.neutral100
          : EcoColorTokens.neutral800,
      elevation: EcoElevation.appBarElevation,
      centerTitle: true,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
  }

  /// Bottom Navigation Bar personnalisée pour EcoPlates
  static Widget ecoBottomNavigationBar({
    required int currentIndex,
    required List<BottomNavigationBarItem> items,
    required ValueChanged<int> onTap,
    bool isDark = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? EcoColorTokens.neutral900 : EcoColorTokens.neutral0,
        boxShadow: EcoElevation.navigationShadow,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(EcoRadius.xl),
          topRight: Radius.circular(EcoRadius.xl),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(EcoRadius.xl),
          topRight: Radius.circular(EcoRadius.xl),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: EcoColorTokens.primary,
          unselectedItemColor: isDark
              ? EcoColorTokens.neutral500
              : EcoColorTokens.neutral400,
          elevation: 0,
          selectedLabelStyle: EcoTypography.labelSmallLight.copyWith(
            color: EcoColorTokens.primary,
            fontWeight: EcoTypography.semiBold,
          ),
          unselectedLabelStyle: EcoTypography.labelSmallLight,
        ),
      ),
    );
  }

  /// Navigation Rail pour desktop
  static Widget ecoNavigationRail({
    required int selectedIndex,
    required List<NavigationRailDestination> destinations,
    required ValueChanged<int> onDestinationSelected,
    Widget? leading,
    Widget? trailing,
    bool extended = false,
    bool isDark = false,
  }) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
      leading: leading,
      trailing: trailing,
      extended: extended,
      backgroundColor: isDark
          ? EcoColorTokens.neutral900
          : EcoColorTokens.neutral50,
      selectedIconTheme: const IconThemeData(
        size: 24,
        color: EcoColorTokens.primary,
      ),
      unselectedIconTheme: IconThemeData(
        size: 22,
        color: isDark ? EcoColorTokens.neutral500 : EcoColorTokens.neutral400,
      ),
      selectedLabelTextStyle: EcoTypography.labelMediumLight.copyWith(
        color: EcoColorTokens.primary,
        fontWeight: EcoTypography.semiBold,
      ),
      unselectedLabelTextStyle: EcoTypography.labelMediumLight.copyWith(
        color: isDark ? EcoColorTokens.neutral500 : EcoColorTokens.neutral400,
      ),
      elevation: EcoElevation.level1,
      minWidth: 80,
      minExtendedWidth: 200,
    );
  }

  /// Drawer personnalisé EcoPlates
  static Widget ecoDrawer({
    required List<Widget> children,
    Widget? header,
    bool isDark = false,
  }) {
    return Drawer(
      backgroundColor: isDark
          ? EcoColorTokens.neutral900
          : EcoColorTokens.neutral0,
      elevation: EcoElevation.drawerElevation,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(EcoRadius.lg),
          bottomRight: Radius.circular(EcoRadius.lg),
        ),
      ),
      child: Column(
        children: [
          ?header,
          Expanded(
            child: ListView(
              padding: EcoSpacing.paddingMD,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  /// Tab Bar avec style EcoPlates
  static Widget ecoTabBar({
    required List<Tab> tabs,
    TabController? controller,
    bool isScrollable = false,
    bool isDark = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? EcoColorTokens.neutral800 : EcoColorTokens.neutral50,
        borderRadius: EcoRadius.tabRadius,
      ),
      child: TabBar(
        tabs: tabs,
        controller: controller,
        isScrollable: isScrollable,
        labelColor: EcoColorTokens.primary,
        unselectedLabelColor: isDark
            ? EcoColorTokens.neutral400
            : EcoColorTokens.neutral500,
        indicatorColor: EcoColorTokens.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EcoSpacing.paddingXS,
        labelStyle: EcoTypography.labelLargeLight.copyWith(
          fontWeight: EcoTypography.semiBold,
        ),
        unselectedLabelStyle: EcoTypography.labelLargeLight,
        dividerColor: Colors.transparent,
      ),
    );
  }
}
