import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ecoplates/domain/entities/stock_item.dart';
import 'package:ecoplates/domain/repositories/stock_repository.dart';
import 'package:ecoplates/domain/usecases/get_stock_items_usecase.dart';

import 'get_stock_items_usecase_test.mocks.dart';

@GenerateMocks([StockRepository])
void main() {
  late MockStockRepository mockRepository;
  late GetStockItemsUseCase useCase;

  setUp(() {
    mockRepository = MockStockRepository();
    useCase = GetStockItemsUseCase(mockRepository);
  });

  group('GetStockItemsUseCase', () {
    final sampleItems = [
      StockItem(
        id: '1',
        name: 'Pommes',
        sku: 'FRT-001',
        category: 'Fruits',
        price: 2.50,
        quantity: 10,
        unit: 'kg',
        status: StockItemStatus.active,
        updatedAt: DateTime.now(),
      ),
      StockItem(
        id: '2',
        name: 'Bananes',
        sku: 'FRT-002',
        category: 'Fruits',
        price: 3.20,
        quantity: 5,
        unit: 'kg',
        status: StockItemStatus.inactive,
        updatedAt: DateTime.now(),
      ),
    ];

    test('should return items from repository with default parameters', () async {
      // Arrange
      when(mockRepository.getStockItems(
        filter: anyNamed('filter'),
        sortBy: anyNamed('sortBy'),
      )).thenAnswer((_) async => sampleItems);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, sampleItems);
      verify(mockRepository.getStockItems(
        sortBy: StockSortOption.nameAsc,
      ));
    });

    test('should normalize empty search query to null', () async {
      // Arrange
      when(mockRepository.getStockItems(
        filter: anyNamed('filter'),
        sortBy: anyNamed('sortBy'),
      )).thenAnswer((_) async => sampleItems);

      const filter = StockItemsFilter(searchQuery: '   ');

      // Act
      final result = await useCase.call(filter: filter);

      // Assert
      expect(result, sampleItems);
      verify(mockRepository.getStockItems(
        sortBy: StockSortOption.nameAsc,
      ));
    });

    test('should normalize search query to lowercase', () async {
      // Arrange
      when(mockRepository.getStockItems(
        filter: anyNamed('filter'),
        sortBy: anyNamed('sortBy'),
      )).thenAnswer((_) async => sampleItems);

      const filter = StockItemsFilter(searchQuery: '  POMMES  ');

      // Act
      final result = await useCase.call(filter: filter);

      // Assert
      expect(result, sampleItems);
      verify(mockRepository.getStockItems(
        filter: const StockItemsFilter(searchQuery: 'pommes'),
      ));
    });

    test('should pass through status filter unchanged', () async {
      // Arrange
      when(mockRepository.getStockItems(
        filter: anyNamed('filter'),
        sortBy: anyNamed('sortBy'),
      )).thenAnswer((_) async => sampleItems);

      const filter = StockItemsFilter(
        status: StockItemStatus.active,
        searchQuery: 'pommes',
      );

      // Act
      final result = await useCase.call(filter: filter);

      // Assert
      expect(result, sampleItems);
      verify(mockRepository.getStockItems(
        filter: const StockItemsFilter(
          status: StockItemStatus.active,
          searchQuery: 'pommes',
        ),
      ));
    });

    test('should use custom sort option', () async {
      // Arrange
      when(mockRepository.getStockItems(
        filter: anyNamed('filter'),
        sortBy: anyNamed('sortBy'),
      )).thenAnswer((_) async => sampleItems);

      // Act
      final result = await useCase.call(
        sortBy: StockSortOption.quantityDesc,
      );

      // Assert
      expect(result, sampleItems);
      verify(mockRepository.getStockItems(
        sortBy: StockSortOption.quantityDesc,
      ));
    });
  });
}