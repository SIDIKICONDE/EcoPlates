import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/stock_item.dart';

/// Service dédié à l'export des données de stock
class StockExportService {
  /// Exporte les données de stock au format CSV
  Future<void> exportStockData(List<StockItem> items) async {
    if (kDebugMode) {
      // Debug: exportStockData called with ${items.length} items
    }

    if (items.isEmpty) {
      if (kDebugMode) {
        // Debug: No items to export
      }
      throw Exception('Aucun article à exporter');
    }

    try {
      // Générer les données CSV
      if (kDebugMode) {
        // Debug: Generating CSV
      }
      final csvData = _generateStockCsv(items);
      if (kDebugMode) {
        // Debug: CSV generated, size: ${csvData.length} characters
      }

      // Créer le fichier temporaire
      final fileName =
          'stock_export_${DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now())}.csv';
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      if (kDebugMode) {
        // Debug: Temporary file: ${file.path}
      }

      // Écrire le contenu CSV
      if (kDebugMode) {
        // Debug: Writing file
      }
      await file.writeAsString(csvData);

      // Vérifier que le fichier existe et a du contenu
      final fileExists = file.existsSync();
      final fileLength = file.lengthSync();
      if (kDebugMode) {
        // Debug: File created: $fileExists, size: $fileLength bytes
      }

      if (!fileExists || fileLength == 0) {
        throw Exception("Échec de création du fichier d'export");
      }

      // Partager le fichier ou sauvegarder sur Windows
      if (kDebugMode) {
        // Debug: Sharing file
      }

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Sur desktop, sauvegarder dans le dossier Documents
        await _saveToDesktop(file, fileName);
        if (kDebugMode) {
          // Debug: File saved to desktop
        }
      } else {
        // Sur mobile, utiliser SharePlus
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Export des données de stock EcoPlates',
          subject:
              'Stock EcoPlates - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
        );
        if (kDebugMode) {
          // Debug: Share successful
        }
      }
    } catch (error) {
      if (kDebugMode) {
        // Debug: Error in exportStockData: $error
      }
      rethrow;
    }
  }

  /// Génère le contenu CSV des données de stock
  String _generateStockCsv(List<StockItem> items) {
    final headers = [
      'SKU',
      'Nom',
      'Catégorie',
      'Prix (€)',
      'Unité',
      'Quantité',
      'Statut',
      'Rupture de stock',
      'Description',
      'Dernière mise à jour',
    ];

    final dataRows = items.map((item) {
      final outOfStockText = item.isOutOfStock ? 'Oui' : 'Non';
      final description = item.description ?? '';

      return [
        item.sku,
        item.name,
        item.category,
        item.price.toStringAsFixed(2).replaceAll('.', ','),
        item.unit,
        item.quantity.toString(),
        item.status.label,
        outOfStockText,
        description,
        DateFormat('dd/MM/yyyy HH:mm').format(item.updatedAt),
      ];
    }).toList();

    // Créer la liste complète avec les en-têtes
    final rows = [headers, ...dataRows];

    // Convertir en CSV
    return const ListToCsvConverter().convert(rows);
  }

  /// Sauvegarde le fichier sur le bureau (Windows/Linux/macOS)
  Future<void> _saveToDesktop(File tempFile, String fileName) async {
    try {
      // Obtenir le répertoire Documents
      final documentsDir = await getDownloadsDirectory();
      if (documentsDir == null) {
        throw Exception("Impossible d'accéder au dossier Téléchargements");
      }

      // Créer le fichier de destination
      final destinationPath =
          '${documentsDir.path}${Platform.pathSeparator}$fileName';
      final destinationFile = File(destinationPath);

      // Copier le fichier temporaire vers la destination
      await tempFile.copy(destinationPath);

      if (kDebugMode) {
        print('DEBUG Service: Fichier sauvegardé dans: $destinationPath');
      }

      // Vérifier que le fichier a bien été créé
      if (!destinationFile.existsSync()) {
        throw Exception('Echec de la sauvegarde du fichier');
      }
    } catch (e) {
      if (kDebugMode) {
        // Debug: Error during save: $e
      }
      rethrow;
    }
  }
}
