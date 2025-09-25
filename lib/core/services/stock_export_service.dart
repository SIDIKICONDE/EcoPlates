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
    print(
      'DEBUG Service: exportStockData appelée avec ${items.length} articles',
    );

    if (items.isEmpty) {
      print('DEBUG Service: Aucun article à exporter');
      throw Exception('Aucun article à exporter');
    }

    try {
      // Générer les données CSV
      print('DEBUG Service: Génération du CSV');
      final csvData = _generateStockCsv(items);
      print('DEBUG Service: CSV généré, taille: ${csvData.length} caractères');

      // Créer le fichier temporaire
      final fileName =
          'stock_export_${DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now())}.csv';
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      print('DEBUG Service: Fichier temporaire: ${file.path}');

      // Écrire le contenu CSV
      print('DEBUG Service: Écriture du fichier');
      await file.writeAsString(csvData);

      // Vérifier que le fichier existe et a du contenu
      final fileExists = await file.exists();
      final fileLength = await file.length();
      print(
        'DEBUG Service: Fichier créé: $fileExists, taille: $fileLength bytes',
      );

      if (!fileExists || fileLength == 0) {
        throw Exception('Échec de création du fichier d\'export');
      }

      // Partager le fichier ou sauvegarder sur Windows
      print('DEBUG Service: Partage du fichier');
      
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Sur desktop, sauvegarder dans le dossier Documents
        await _saveToDesktop(file, fileName);
        print('DEBUG Service: Fichier sauvegardé sur le bureau');
      } else {
        // Sur mobile, utiliser Share
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Export des données de stock EcoPlates',
          subject:
              'Stock EcoPlates - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
        );
        print('DEBUG Service: Partage réussi');
      }
    } catch (error, stackTrace) {
      print('DEBUG Service: Erreur dans exportStockData: $error');
      print('DEBUG Service: StackTrace: $stackTrace');
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

    final rows = items.map((item) {
      return [
        item.sku,
        item.name,
        item.category,
        item.price.toStringAsFixed(2).replaceAll('.', ','),
        item.unit,
        item.quantity.toString(),
        item.status.label,
        item.isOutOfStock ? 'Oui' : 'Non',
        item.description ?? '',
        DateFormat('dd/MM/yyyy HH:mm').format(item.updatedAt),
      ];
    }).toList();

    // Ajouter les en-têtes au début
    rows.insert(0, headers);

    // Convertir en CSV
    return const ListToCsvConverter().convert(rows);
  }
  
  /// Sauvegarde le fichier sur le bureau (Windows/Linux/macOS)
  Future<void> _saveToDesktop(File tempFile, String fileName) async {
    try {
      // Obtenir le répertoire Documents
      final Directory? documentsDir = await getDownloadsDirectory();
      if (documentsDir == null) {
        throw Exception('Impossible d\'accéder au dossier Téléchargements');
      }
      
      // Créer le fichier de destination
      final destinationPath = '${documentsDir.path}${Platform.pathSeparator}$fileName';
      final destinationFile = File(destinationPath);
      
      // Copier le fichier temporaire vers la destination
      await tempFile.copy(destinationPath);
      
      if (kDebugMode) {
        print('DEBUG Service: Fichier sauvegardé dans: $destinationPath');
      }
      
      // Vérifier que le fichier a bien été créé
      if (!await destinationFile.exists()) {
        throw Exception('Echec de la sauvegarde du fichier');
      }
    } catch (e) {
      print('DEBUG Service: Erreur lors de la sauvegarde: $e');
      rethrow;
    }
  }
}
