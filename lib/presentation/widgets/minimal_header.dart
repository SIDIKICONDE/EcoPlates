import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common/location_header.dart';

/// En-tête minimaliste, élégant et professionnel
/// - Hauteur compacte (48px par défaut)
/// - Fond neutre (surface)
/// - Légère bordure inférieure pour la séparation
/// - Titre centré, leading et actions optionnels
class MinimalHeader extends StatelessWidget implements PreferredSizeWidget {

  const MinimalHeader({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.height = 48,
    this.showBottomDivider = true,
    this.backgroundColor,
    this.horizontalPadding = 12,
    this.showLocationInstead = false,
  });
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;
  final bool showBottomDivider;
  final Color? backgroundColor;
  final double horizontalPadding;
  final bool showLocationInstead;

  @override
  Size get preferredSize => Size.fromHeight(height + (kIsWeb ? 0 : 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surface;
    final dividerColor = theme.dividerColor.withValues(alpha: 0.08);

    // Si aucune action n'est fournie, on réserve l'espace pour éviter les "sauts"
    final right = actions == null || actions!.isEmpty
        ? const SizedBox(width: 44)
        : Row(mainAxisSize: MainAxisSize.min, children: actions!);

    return Material(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: Container
          (
          height: height,
          decoration: BoxDecoration(
            border: showBottomDivider
                ? Border(
                    bottom: BorderSide(color: dividerColor),
                  )
                : null,
          ),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              // Leading (ex: bouton retour ou logo compact)
              leading ?? const SizedBox(width: 44),

              // Titre centré ou localisation
              Expanded(
                child: showLocationInstead
                    ? const Center(
                        child: LocationHeader(
                          
                        ),
                      )
                    : Text(
                        title ?? '',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              // Actions (ex: icône de recherche, panier, etc.)
              right,
            ],
          ),
        ),
      ),
    );
  }
}
