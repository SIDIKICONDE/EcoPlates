import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecoplates/core/services/qr_code_service.dart';
import 'package:ecoplates/core/services/qr_scanner_service.dart';
import 'package:ecoplates/core/services/qr_security_config_service.dart';
import 'package:ecoplates/core/services/secure_storage_service.dart';
import 'package:ecoplates/core/services/time_sync_service.dart';
import 'package:ecoplates/core/services/totp_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'qr_security_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late MockDio mockDio;
  late MockLoggerService mockLogger;

  late SecureStorageService storage;
  late TimeSyncService timeSync;
  late QRSecurityConfigService config;
  late TOTPService totp;
  late QRCodeService qrCode;
  late QRScannerService scanner;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockDio = MockDio();
    mockLogger = MockLoggerService();

    // Config défaut via échec réseau
    when(
      mockDio.get<Map<String, dynamic>>(any),
    ).thenThrow(DioException(requestOptions: RequestOptions()));

    storage = SecureStorageService(storage: mockStorage, logger: mockLogger);
    timeSync = TimeSyncService(dio: mockDio, logger: mockLogger);
    config = QRSecurityConfigService(dio: mockDio, logger: mockLogger);
    totp = TOTPService(
      timeSyncService: timeSync,
      configService: config,
      logger: mockLogger,
    );
    qrCode = QRCodeService(
      secureStorage: storage,
      totpService: totp,
      configService: config,
      timeSyncService: timeSync,
      logger: mockLogger,
    );
    scanner = QRScannerService(
      qrCodeService: qrCode,
      dio: mockDio,
      logger: mockLogger,
    );
  });

  test('clearOfflineScans vide le cache', () async {
    final payload = {
      'v': '2.0',
      'merchant_id': 'm1',
      'consumer_id': 'c1',
      'order_id': 'o1',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'token': '12345678',
      'sig': 'sig',
    };
    final qrData = base64Url.encode(utf8.encode(jsonEncode(payload)));

    when(
      mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenThrow(DioException(requestOptions: RequestOptions()));

    await scanner.processScan(qrData, merchantId: 'm1');
    expect(scanner.pendingScansCount, 1);

    scanner.clearOfflineScans();
    expect(scanner.pendingScansCount, 0);
  });
}
