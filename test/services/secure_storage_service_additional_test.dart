import 'dart:convert';

import 'package:ecoplates/core/services/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'qr_security_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late MockLoggerService mockLogger;
  late SecureStorageService storageService;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockLogger = MockLoggerService();
    storageService = SecureStorageService(
      storage: mockStorage,
      logger: mockLogger,
    );
  });

  test('deleteTOTPSecret appelle la suppression avec la bonne clé', () async {
    when(
      mockStorage.delete(
        key: anyNamed('key'),
        iOptions: anyNamed('iOptions'),
        aOptions: anyNamed('aOptions'),
      ),
    ).thenAnswer((_) async {});

    await storageService.deleteTOTPSecret('orderXYZ');
    verify(
      mockStorage.delete(
        key: 'order_secret_orderXYZ',
        iOptions: anyNamed('iOptions'),
        aOptions: anyNamed('aOptions'),
      ),
    ).called(1);
  });

  test('getAllTOTPSecrets mappe correctement les entrées', () async {
    final nowIso = DateTime.now().toIso8601String();
    final v1 = jsonEncode({'secret': 's1', 'createdAt': nowIso});
    final v2 = jsonEncode({'secret': 's2', 'createdAt': nowIso});

    when(
      mockStorage.readAll(
        iOptions: anyNamed('iOptions'),
        aOptions: anyNamed('aOptions'),
      ),
    ).thenAnswer(
      (_) async => {
        'order_secret_A': v1,
        'not_related': 'x',
        'order_secret_B': v2,
      },
    );

    final all = await storageService.getAllTOTPSecrets();
    expect(all.keys, containsAll(['A', 'B']));
    expect(all['A']!.secret, 's1');
    expect(all['B']!.secret, 's2');
  });
}
