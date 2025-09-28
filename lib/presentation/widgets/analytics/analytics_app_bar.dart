import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/widgets/adaptive_widgets.dart';
import '../../providers/analytics_provider.dart';

/// Barre d'app bar pour la page d'analyse des marchands
///
/// Affiche le titre, le logo marchand et les actions rapides
/// (rafraîchir, exporter, paramètres)
class AnalyticsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AnalyticsAppBar({super.key});

  @override
  ui.Size get preferredSize => ui.Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AdaptiveAppBar(
      leading: const _MerchantLogo(),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              AnalyticsAppBarTokens.titlePadding(context),
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(
                AnalyticsAppBarTokens.borderRadius(context),
              ),
            ),
            child: Icon(
              Icons.insights,
              size: EcoPlatesDesignTokens.size.icon(context),
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: EcoPlatesDesignTokens.spacing.smallGap(context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Business Insights',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                  letterSpacing: EcoPlatesDesignTokens.typography
                      .titleLetterSpacing(context),
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Analytics Dashboard',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: AnalyticsAppBarTokens.fontSizeTiny(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Bouton de rafraîchissement amélioré
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: AnalyticsAppBarTokens.horizontalMargin(context),
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(
              AnalyticsAppBarTokens.borderRadius(context),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: AnalyticsAppBarTokens.iconSize(context),
            tooltip: 'Actualiser les données',
            onPressed: () => ref.refreshAnalytics(),
            style: IconButton.styleFrom(
              padding: EdgeInsets.all(
                AnalyticsAppBarTokens.paddingAll(context),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AnalyticsAppBarTokens.borderRadius(context),
                ),
              ),
            ),
          ),
        ),

        // Menu d'actions amélioré
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: AnalyticsAppBarTokens.horizontalMargin(context),
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(
              AnalyticsAppBarTokens.borderRadius(context),
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            iconSize: AnalyticsAppBarTokens.iconSize(context),
            tooltip: 'Actions',
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export_pdf',
                child: ListTile(
                  leading: Icon(
                    Icons.picture_as_pdf,
                    size: AnalyticsAppBarTokens.menuIconSize(context),
                    color: Color(AnalyticsAppBarTokens.pdfIconColor),
                  ),
                  title: Text(
                    'Exporter PDF',
                    style: TextStyle(
                      fontSize: AnalyticsAppBarTokens.fontSizeMedium(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AnalyticsAppBarTokens.contentHorizontalPadding(
                      context,
                    ),
                  ),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'export_excel',
                child: ListTile(
                  leading: Icon(
                    Icons.table_chart,
                    size: AnalyticsAppBarTokens.menuIconSize(context),
                    color: Color(AnalyticsAppBarTokens.excelIconColor),
                  ),
                  title: Text(
                    'Exporter Excel',
                    style: TextStyle(
                      fontSize: AnalyticsAppBarTokens.fontSizeMedium(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AnalyticsAppBarTokens.contentHorizontalPadding(
                      context,
                    ),
                  ),
                  dense: true,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    size: AnalyticsAppBarTokens.menuIconSize(context),
                    color: Color(AnalyticsAppBarTokens.settingsIconColor),
                  ),
                  title: Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: AnalyticsAppBarTokens.fontSizeMedium(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AnalyticsAppBarTokens.contentHorizontalPadding(
                      context,
                    ),
                  ),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'help',
                child: ListTile(
                  leading: Icon(
                    Icons.help_outline,
                    size: AnalyticsAppBarTokens.menuIconSize(context),
                    color: Color(AnalyticsAppBarTokens.helpIconColor),
                  ),
                  title: Text(
                    'Aide',
                    style: TextStyle(
                      fontSize: AnalyticsAppBarTokens.fontSizeMedium(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AnalyticsAppBarTokens.contentHorizontalPadding(
                      context,
                    ),
                  ),
                  dense: true,
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AnalyticsAppBarTokens.popupBorderRadius(context),
              ),
            ),
            elevation: AnalyticsAppBarTokens.elevation(context),
          ),
        ),

        SizedBox(width: AnalyticsAppBarTokens.paddingAll(context)),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'export_pdf':
        _showExportDialog(context, 'PDF');
      case 'export_excel':
        _showExportDialog(context, 'Excel');
      case 'settings':
        _showSettingsDialog(context);
      case 'help':
        _showHelpDialog(context);
    }
  }

  void _showExportDialog(BuildContext context, String format) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exporter en $format'),
          content: Text(
            "Voulez-vous exporter les données d'analyse actuelles au format $format ?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performExport(context, format);
              },
              child: const Text('Exporter'),
            ),
          ],
        ),
      ),
    );
  }

  void _performExport(BuildContext context, String format) {
    // TODO(export): Implémenter l'export réel
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export $format en cours...'),
        duration: AnalyticsAppBarTokens.exportSimulationDuration,
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Simuler l'export
    Future.delayed(AnalyticsAppBarTokens.exportSimulationDuration, () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rapport $format exporté avec succès !'),
            backgroundColor: Colors.green,
            duration: AnalyticsAppBarTokens.snackBarDuration,
          ),
        );
      }
    });
  }

  void _showSettingsDialog(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Paramètres d'analyse"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Période par défaut: Cette semaine'),
              Text('• Devise: Euro (€)'),
              Text('• Format de date: jj/mm/aaaa'),
              Text('• Fuseaux horaire: Europe/Paris'),
              SizedBox(height: AnalyticsAppBarTokens.spacingLarge(context)),
              Text(
                'Ces paramètres peuvent être modifiés dans les réglages généraux.',
                style: TextStyle(
                  fontSize: AnalyticsAppBarTokens.fontSizeSmall(context),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO(settings): Navigation vers les paramètres
              },
              child: const Text('Paramètres'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aide - Analytics'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 KPIs principaux',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AnalyticsAppBarTokens.spacingMedium(context)),
                const Text("• CA: Chiffre d'affaires total"),
                const Text('• Commandes: Nombre de ventes'),
                const Text('• Panier moyen: CA ÷ Commandes'),
                const Text('• Taux conversion: % visiteurs → acheteurs'),
                SizedBox(height: AnalyticsAppBarTokens.spacingLarge(context)),
                const Text(
                  '📈 Graphiques',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AnalyticsAppBarTokens.spacingMedium(context)),
                const Text('• Évolution des revenus dans le temps'),
                const Text('• Répartition des ventes par produit'),
                const Text('• Analyse par catégories'),
                SizedBox(height: AnalyticsAppBarTokens.spacingLarge(context)),
                const Text(
                  '🔄 Périodes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AnalyticsAppBarTokens.spacingSmall(context)),
                const Text('• 24h: Données horaires'),
                const Text('• 7j: Données journalières'),
                const Text('• 30j: Données hebdomadaires'),
                const Text('• 1an: Données mensuelles'),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Compris'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Logo du marchand dans la barre d'app bar
class _MerchantLogo extends StatelessWidget {
  const _MerchantLogo();

  @override
  Widget build(BuildContext context) {
    const merchantLogoUrl = AnalyticsAppBarTokens.merchantLogoUrl;

    return Container(
      margin: EdgeInsets.all(AnalyticsAppBarTokens.paddingAll(context)),
      child: CircleAvatar(
        radius: AnalyticsAppBarTokens.avatarRadius(context),
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundImage: const NetworkImage(merchantLogoUrl),
        onBackgroundImageError: (_, error) {
          // Fallback vers une icône si l'image ne charge pas
        },
        child: Icon(
          Icons.analytics,
          size: AnalyticsAppBarTokens.iconSize(context),
          color: Colors.grey,
        ),
      ),
    );
  }
}
