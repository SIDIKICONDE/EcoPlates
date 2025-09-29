import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              Icons.insights,
              size: 16.0,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Business Insights',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Analytics Dashboard',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12.0,
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
            horizontal: 4.0,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 20.0,
            tooltip: 'Actualiser les données',
            onPressed: () => ref.refreshAnalytics(),
            style: IconButton.styleFrom(
              padding: EdgeInsets.all(
                8.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
            ),
          ),
        ),

        // Menu d'actions amélioré
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 4.0,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            iconSize: 20.0,
            tooltip: 'Actions',
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export_pdf',
                child: ListTile(
                  leading: Icon(
                    Icons.picture_as_pdf,
                    size: 20.0,
                    color: const Color(0xFFDC2626),
                  ),
                  title: Text(
                    'Exporter PDF',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'export_excel',
                child: ListTile(
                  leading: Icon(
                    Icons.table_chart,
                    size: 20.0,
                    color: const Color(0xFF16A34A),
                  ),
                  title: Text(
                    'Exporter Excel',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
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
                    size: 20.0,
                    color: const Color(0xFF6B7280),
                  ),
                  title: Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'help',
                child: ListTile(
                  leading: Icon(
                    Icons.help_outline,
                    size: 20.0,
                    color: const Color(0xFF2563EB),
                  ),
                  title: Text(
                    'Aide',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  dense: true,
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            elevation: 4.0,
          ),
        ),

        SizedBox(width: 8.0),
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
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Simuler l'export
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rapport $format exporté avec succès !'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
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
            children: const [
              Text('• Période par défaut: Cette semaine'),
              Text('• Devise: Euro (€)'),
              Text('• Format de date: jj/mm/aaaa'),
              Text('• Fuseaux horaire: Europe/Paris'),
              SizedBox(height: 16.0),
              Text(
                'Ces paramètres peuvent être modifiés dans les réglages généraux.',
                style: TextStyle(
                  fontSize: 13.0,
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
              children: const [
                Text(
                  '📊 KPIs principaux',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.0),
                Text("• CA: Chiffre d'affaires total"),
                Text('• Commandes: Nombre de ventes'),
                Text('• Panier moyen: CA ÷ Commandes'),
                Text('• Taux conversion: % visiteurs → acheteurs'),
                SizedBox(height: 16.0),
                Text(
                  '📈 Graphiques',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.0),
                Text('• Évolution des revenus dans le temps'),
                Text('• Répartition des ventes par produit'),
                Text('• Analyse par catégories'),
                SizedBox(height: 16.0),
                Text(
                  '🔄 Périodes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text('• 24h: Données horaires'),
                Text('• 7j: Données journalières'),
                Text('• 30j: Données hebdomadaires'),
                Text('• 1an: Données mensuelles'),
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
    const merchantLogoUrl =
        'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=Logo';

    return Container(
      margin: EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 16.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundImage: const NetworkImage(merchantLogoUrl),
        onBackgroundImageError: (_, error) {
          // Fallback vers une icône si l'image ne charge pas
        },
        child: Icon(
          Icons.analytics,
          size: 20.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
