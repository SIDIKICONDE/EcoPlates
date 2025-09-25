import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/stock_export_service.dart';
import '../../domain/repositories/stock_repository.dart';
import '../providers/stock_items_provider.dart';

/// Contrôleur pour gérer les actions de la page de stock des marchands
///
/// Sépare la logique métier des actions (tri, export, refresh) de l'UI.
class MerchantStockController {
  const MerchantStockController();

  /// Actualise la liste des articles en stock
  void refreshStock(BuildContext context, WidgetRef ref) {
    ref.read(stockItemsProvider.notifier).refresh();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Actualisation en cours...')));
  }

  /// Affiche la feuille de tri et applique le tri sélectionné
  Future<void> showSortSheet(BuildContext context, WidgetRef ref) async {
    final current = ref.read(stockFiltersProvider);

    final selected = await showModalBottomSheet<StockSortOption>(
      context: context,
      builder: (ctx) {
        final options = StockSortOption.values;
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(title: Text('Trier par')),
              ...options.map(
                (StockSortOption opt) => ListTile(
                  title: Text(opt.label),
                  leading: Icon(
                    opt == current.sortBy
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: opt == current.sortBy
                        ? Theme.of(ctx).colorScheme.primary
                        : null,
                  ),
                  onTap: () => Navigator.of(ctx).pop(opt),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null && selected != current.sortBy) {
      // Mettre à jour filtre
      final notifier = ref.read(stockFiltersProvider.notifier);
      notifier.state = current.copyWith(sortBy: selected);

      // Persister
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('stock_sort_option', selected.name);

      // Rafraîchir la liste
      await ref.read(stockItemsProvider.notifier).refresh();
    }
  }

  /// Exporte les données de stock au format CSV
  Future<void> exportStockData(BuildContext context, WidgetRef ref) async {
    try {
      // Vérifier s'il y a des articles à exporter
      final stockItems = ref.read(stockItemsProvider).value ?? [];

      if (stockItems.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aucun article à exporter'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Afficher un indicateur de chargement
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export de ${stockItems.length} articles...'),
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // Utiliser le service d'export
      final exportService = StockExportService();
      await exportService.exportStockData(stockItems);

      // Afficher le succès avec info spécifique à Windows
      if (context.mounted) {
        final isDesktop =
            Theme.of(context).platform == TargetPlatform.windows ||
            Theme.of(context).platform == TargetPlatform.linux ||
            Theme.of(context).platform == TargetPlatform.macOS;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isDesktop
                  ? 'Export réussi ! Fichier sauvegardé dans Téléchargements'
                  : 'Export réussi !',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: isDesktop
                ? SnackBarAction(
                    label: 'OK',
                    textColor: Colors.white,
                    onPressed: () {},
                  )
                : null,
          ),
        );
      }
    } catch (error) {
      // Afficher l'erreur avec plus de détails
      debugPrint('Erreur export: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString().contains('accéder au dossier')
                  ? "Impossible d'accéder au dossier Téléchargements"
                  : "Erreur lors de l'export: ${error.toString()}",
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Gère les actions du menu popup
  void handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'refresh':
        refreshStock(context, ref);
      case 'sort':
        showSortSheet(context, ref);
      case 'export':
        exportStockData(context, ref);
    }
  }
}

/// Provider pour le contrôleur de stock
final merchantStockControllerProvider = Provider<MerchantStockController>(
  (ref) => const MerchantStockController(),
);
