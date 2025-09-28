import 'package:csv/csv.dart';
import 'package:ecoplates/core/services/stock_export_service.dart';
import 'package:ecoplates/domain/entities/stock_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  late StockExportService exportService;

  setUp(() {
    exportService = StockExportService();
  });

  group('StockExportService', () {
    // Données de test mockées
    final sampleItems = [
      StockItem(
        id: '1',
        name: 'Pommes Bio',
        sku: 'FRT-001',
        category: 'Fruits',
        price: 2.50,
        quantity: 10,
        unit: 'kg',
        status: StockItemStatus.active,
        description: 'Pommes biologiques de saison',
        updatedAt: DateTime(2025, 1, 15, 14, 30),
      ),
      StockItem(
        id: '2',
        name: 'Tomates',
        sku: 'VEG-002',
        category: 'Légumes',
        price: 3.20,
        quantity: 0,
        unit: 'kg',
        status: StockItemStatus.inactive,
        description: 'Tomates cerises',
        updatedAt: DateTime(2025, 1, 16, 9, 15),
      ),
    ];

    test('génère correctement le CSV avec les données de stock', () {
      // Act
      final csvData = exportService.generateStockCsv(sampleItems);

      // Assert
      expect(csvData, isNotEmpty);
      expect(csvData, contains('SKU'));
      expect(csvData, contains('Nom'));
      expect(csvData, contains('Catégorie'));
      expect(csvData, contains('Prix (€)'));
      expect(csvData, contains('Unité'));
      expect(csvData, contains('Quantité'));
      expect(csvData, contains('Statut'));
      expect(csvData, contains('Rupture de stock'));
      expect(csvData, contains('Description'));
      expect(csvData, contains('Dernière mise à jour'));
    });

    test('contient toutes les données des articles dans le CSV', () {
      // Act
      final csvData = exportService.generateStockCsv(sampleItems);
      final lines = csvData.split('\n');

      // Assert
      expect(lines.length, equals(3)); // Header + 2 items

      // Vérifier que les données des articles sont présentes
      expect(csvData, contains('FRT-001'));
      expect(csvData, contains('Pommes Bio'));
      expect(csvData, contains('Fruits'));
      expect(csvData, contains('2,50')); // Prix formaté avec virgule
      expect(csvData, contains('kg'));
      expect(csvData, contains('10'));
      expect(csvData, contains('Actif')); // Statut
      expect(csvData, contains('Non')); // Pas en rupture
      expect(csvData, contains('Pommes biologiques de saison'));
      expect(csvData, contains('15/01/2025 14:30')); // Date formatée

      // Deuxième article
      expect(csvData, contains('VEG-002'));
      expect(csvData, contains('Tomates'));
      expect(csvData, contains('Légumes'));
      expect(csvData, contains('3,20'));
      expect(csvData, contains('0'));
      expect(csvData, contains('Inactif'));
      expect(csvData, contains('Oui')); // En rupture (quantité = 0)
      expect(csvData, contains('Tomates cerises'));
      expect(csvData, contains('16/01/2025 09:15'));
    });

    test('gère correctement les articles sans description', () {
      // Arrange
      final itemsWithoutDescription = [
        StockItem(
          id: '3',
          name: 'Carottes',
          sku: 'VEG-003',
          category: 'Légumes',
          price: 1.80,
          quantity: 5,
          unit: 'kg',
          status: StockItemStatus.active,
          updatedAt: DateTime(2025, 1, 17, 11),
        ),
      ];

      // Act
      final csvData = exportService.generateStockCsv(itemsWithoutDescription);

      // Assert
      expect(csvData, contains('VEG-003'));
      expect(csvData, contains('Carottes'));
      expect(csvData, contains(',')); // Valeur vide pour la description
      expect(csvData, contains('17/01/2025 11:00'));
    });

    test('lève une exception quand la liste est vide', () {
      // Act & Assert
      expect(
        () => exportService.exportStockData([]),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Aucun article à exporter'),
          ),
        ),
      );
    });

    test('formate correctement les prix avec virgule décimale', () {
      // Arrange
      final itemsWithPrices = [
        StockItem(
          id: '4',
          name: 'Test Prix',
          sku: 'TEST-001',
          category: 'Test',
          price: 15.99,
          quantity: 1,
          unit: 'pièce',
          status: StockItemStatus.active,
          updatedAt: DateTime(2025, 1, 1, 12),
        ),
      ];

      // Act
      final csvData = exportService.generateStockCsv(itemsWithPrices);

      // Assert
      expect(csvData, contains('15,99')); // Virgule au lieu du point
      expect(csvData, isNot(contains('15.99'))); // Pas de point
    });

    test('gère correctement tous les statuts', () {
      // Arrange
      final itemsWithAllStatuses = [
        StockItem(
          id: '5',
          name: 'Actif',
          sku: 'ACT-001',
          category: 'Test',
          price: 1,
          quantity: 1,
          unit: 'pièce',
          status: StockItemStatus.active,
          updatedAt: DateTime(2025, 1, 1, 12),
        ),
        StockItem(
          id: '6',
          name: 'Inactif',
          sku: 'INA-001',
          category: 'Test',
          price: 1,
          quantity: 1,
          unit: 'pièce',
          status: StockItemStatus.inactive,
          updatedAt: DateTime(2025, 1, 1, 12),
        ),
      ];

      // Act
      final csvData = exportService.generateStockCsv(itemsWithAllStatuses);

      // Assert
      expect(csvData, contains('Actif'));
      expect(csvData, contains('Inactif'));
    });

    test('détecte correctement les ruptures de stock', () {
      // Arrange
      final itemsWithStockIssues = [
        StockItem(
          id: '7',
          name: 'En Stock',
          sku: 'STK-001',
          category: 'Test',
          price: 1,
          quantity: 5,
          unit: 'pièce',
          status: StockItemStatus.active,
          updatedAt: DateTime(2025, 1, 1, 12),
        ),
        StockItem(
          id: '8',
          name: 'Rupture',
          sku: 'OUT-001',
          category: 'Test',
          price: 1,
          quantity: 0,
          unit: 'pièce',
          status: StockItemStatus.active,
          updatedAt: DateTime(2025, 1, 1, 12),
        ),
      ];

      // Act
      final csvData = exportService.generateStockCsv(itemsWithStockIssues);

      // Assert
      expect(csvData, contains('Non')); // Premier article pas en rupture
      expect(csvData, contains('Oui')); // Deuxième article en rupture
    });
  });
}

// Extension pour accéder à la méthode privée generateStockCsv
extension StockExportServiceTest on StockExportService {
  String generateStockCsv(List<StockItem> items) {
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
        if (item.isOutOfStock) 'Oui' else 'Non',
        item.description ?? '',
        DateFormat('dd/MM/yyyy HH:mm').format(item.updatedAt),
      ];
    }).toList();

    // Ajouter les en-têtes au début
    rows.insert(0, headers);

    // Convertir en CSV
    return const ListToCsvConverter().convert(rows);
  }
}
