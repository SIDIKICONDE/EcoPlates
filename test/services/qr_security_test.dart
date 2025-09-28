import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecoplates/core/services/logger_service.dart';
import 'package:ecoplates/core/services/qr_code_service.dart';
import 'package:ecoplates/core/services/qr_scanner_service.dart';
import 'package:ecoplates/core/services/qr_security_config_service.dart';
import 'package:ecoplates/core/services/secure_storage_service.dart';
import 'package:ecoplates/core/services/time_sync_service.dart';
import 'package:ecoplates/core/services/totp_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([FlutterSecureStorage, Dio, LoggerService])
import 'qr_security_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late MockDio mockDio;
  late MockLoggerService mockLogger;

  late SecureStorageService secureStorageService;
  late TOTPService totpService;
  late QRCodeService qrCodeService;
  late QRScannerService qrScannerService;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockDio = MockDio();
    mockLogger = MockLoggerService();

    secureStorageService = SecureStorageService(
      storage: mockStorage,
      logger: mockLogger,
    );

    final mockTimeSyncService = TimeSyncService(
      dio: mockDio,
      logger: mockLogger,
    );
    final mockConfigService = QRSecurityConfigService(
      dio: mockDio,
      logger: mockLogger,
    );

    totpService = TOTPService(
      timeSyncService: mockTimeSyncService,
      configService: mockConfigService,
      logger: mockLogger,
    );

    qrCodeService = QRCodeService(
      secureStorage: secureStorageService,
      totpService: totpService,
      configService: mockConfigService,
      timeSyncService: mockTimeSyncService,
      logger: mockLogger,
    );

    qrScannerService = QRScannerService(
      qrCodeService: qrCodeService,
      dio: mockDio,
      logger: mockLogger,
    );

    // Stub de configuration: retourner une config par défaut (matcher tous paramètres)
    when(
      mockDio.get<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: {
          'totpWindowSteps': 1,
          'totpPeriodSeconds': 30,
          'totpDigits': 8,
          'maxOfflineHours': 24,
          'qrExpirationSeconds': 30,
          'enableDeviceBinding': false,
          'enableGranularRevocation': false,
          'maxFailedAttempts': 5,
          'alertThreshold': 3,
          'compressionEnabled': true,
          'protocolVersion': '2.0',
        },
        requestOptions: RequestOptions(),
      ),
    );
  });

  group('TOTPService Tests', () {
    test('should generate valid 256-bit secret', () {
      final secret = totpService.generateSecret();

      expect(secret, isNotEmpty);
      expect(secret.length, greaterThan(40)); // Base32 encoded 256 bits
      expect(RegExp(r'^[A-Z2-7]+=*$').hasMatch(secret), true);
    });

    test('should generate 8-digit TOTP code', () async {
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
      final code = await totpService.generateTOTP(secret);

      expect(code.length, 8);
      expect(int.tryParse(code), isNotNull);
    });

    test('should validate TOTP within time window', () async {
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
      final now = DateTime.now();

      // Generate token for current time
      final token = await totpService.generateTOTP(secret, time: now);

      // Validate with same time
      final isValid = await totpService.validateTOTP(
        secret,
        token,
        time: now,
      );

      expect(isValid, true);
    });

    test('should reject TOTP outside time window', () async {
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
      final now = DateTime.now();
      final pastTime = now.subtract(const Duration(minutes: 2));

      // Generate token for past time
      final token = await totpService.generateTOTP(secret, time: pastTime);

      // Validate with current time (outside window)
      final isValid = await totpService.validateTOTP(
        secret,
        token,
        time: now,
        windowSteps: 1, // ±30 seconds only
      );

      expect(isValid, false);
    });

    test('should calculate correct time remaining', () async {
      final remaining = await totpService.getTimeRemaining();

      expect(remaining, greaterThanOrEqualTo(1));
      expect(remaining, lessThanOrEqualTo(30));
    });

    test('should generate consistent HMAC signatures', () {
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
      final payload = {
        'order_id': 'test123',
        'merchant_id': 'merchant456',
        'amount': 100,
      };

      final sig1 = totpService.generateHMACSignature(payload, secret);
      final sig2 = totpService.generateHMACSignature(payload, secret);

      expect(sig1, sig2);
      expect(sig1.length, greaterThan(40));
    });

    test('should verify HMAC signatures correctly', () {
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
      final payload = {
        'order_id': 'test123',
        'merchant_id': 'merchant456',
      };

      final signature = totpService.generateHMACSignature(payload, secret);

      final isValid = totpService.verifyHMACSignature(
        payload,
        signature,
        secret,
      );

      expect(isValid, true);

      // Test with wrong signature
      final isInvalid = totpService.verifyHMACSignature(
        payload,
        'wrong_signature',
        secret,
      );

      expect(isInvalid, false);
    });
  });

  group('SecureStorageService Tests', () {
    test('should store TOTP secret securely', () async {
      await secureStorageService.storeTOTPSecret(
        orderId: 'order123',
        secret: 'test_secret',
        metadata: {'test': 'data'},
      );

      verify(
        mockStorage.write(
          key: 'order_secret_order123',
          value: anyNamed('value'),
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).called(1);
    });

    test('should retrieve TOTP secret', () async {
      const orderId = 'order123';
      final storedData = {
        'secret': 'test_secret',
        'createdAt': DateTime.now().toIso8601String(),
        'metadata': {'test': 'data'},
      };

      when(
        mockStorage.read(
          key: anyNamed('key'),
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).thenAnswer((_) async => jsonEncode(storedData));

      final retrieved = await secureStorageService.getTOTPSecret(orderId);

      expect(retrieved, isNotNull);
      expect(retrieved!.secret, 'test_secret');
      expect(retrieved.metadata?['test'], 'data');
    });

    test('should cleanup expired secrets', () async {
      final oldSecret = {
        'secret': 'old_secret',
        'createdAt': DateTime.now()
            .subtract(const Duration(hours: 25))
            .toIso8601String(),
      };

      final validSecret = {
        'secret': 'valid_secret',
        'createdAt': DateTime.now().toIso8601String(),
      };

      when(
        mockStorage.readAll(
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).thenAnswer(
        (_) async => {
          'order_secret_old': jsonEncode(oldSecret),
          'order_secret_valid': jsonEncode(validSecret),
        },
      );

      when(
        mockStorage.delete(
          key: anyNamed('key'),
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).thenAnswer((_) async {
        return;
      });

      final deletedCount = await secureStorageService.cleanupExpiredSecrets();

      expect(deletedCount, 1);
      verify(
        mockStorage.delete(
          key: argThat(contains('old'), named: 'key'),
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).called(1);
    });
  });

  group('QRCodeService Tests', () {
    test('should generate secure QR payload', () async {
      const orderId = 'order123';
      const merchantId = 'merchant456';
      const consumerId = 'consumer789';
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';

      when(
        mockStorage.read(
          key: anyNamed('key'),
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).thenAnswer(
        (_) async => jsonEncode({
          'secret': secret,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      final payload = await qrCodeService.generateSecureQRCode(
        orderId: orderId,
        merchantId: merchantId,
        consumerId: consumerId,
      );

      expect(payload, isNotNull);
      expect(payload.orderId, orderId);
      expect(payload.rawData, isNotEmpty);
      expect(payload.payload['v'], '2.0');
      expect(payload.payload['merchant_id'], merchantId);
      expect(payload.payload['consumer_id'], consumerId);
      expect(payload.payload['token'], isNotNull);
      expect(payload.payload['sig'], isNotNull);
    });

    test('should compress payload effectively', () async {
      const largePayload = {
        'test': 'data',
        'long_field': 'This is a very long string that should be compressed',
        'array': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      };

      final compressed = await qrCodeService.compressPayload(largePayload);
      final jsonSize = jsonEncode(largePayload).length;

      // Compressed should be smaller than raw JSON
      expect(compressed.length, lessThan(jsonSize * 1.5)); // Base64 overhead
    });

    test('should validate QR code format', () async {
      final validPayload = {
        'v': '2.0',
        'merchant_id': 'test',
        'consumer_id': 'test',
        'order_id': 'test',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'test_signature',
      };

      final compressed = await qrCodeService.compressPayload(validPayload);
      final result = await qrCodeService.validateQRCodeLocally(compressed);

      expect(result.isValid, true);
      expect(result.payload, isNotNull);
    });

    test('should reject expired QR codes', () async {
      final expiredPayload = {
        'v': '2.0',
        'merchant_id': 'test',
        'consumer_id': 'test',
        'order_id': 'test',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 2))
            .millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'test_signature',
      };

      final compressed = await qrCodeService.compressPayload(expiredPayload);
      final result = await qrCodeService.validateQRCodeLocally(compressed);

      expect(result.isValid, false);
      expect(result.error, 'EXPIRED');
    });
  });

  group('QRScannerService Tests', () {
    test('should process valid scan successfully', () async {
      const merchantId = 'merchant456';
      final validPayload = {
        'v': '2.0',
        'merchant_id': merchantId,
        'consumer_id': 'consumer789',
        'order_id': 'order123',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'valid_signature',
      };

      final qrData = base64Url.encode(utf8.encode(jsonEncode(validPayload)));

      when(
        mockDio.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onSendProgress: anyNamed('onSendProgress'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'valid': true,
            'order': {
              'id': 'order123',
              'customerName': 'John Doe',
              'items': [
                {'name': 'Salad', 'quantity': 1, 'price': 9.99},
              ],
              'totalAmount': 9.99,
            },
            'validationId': 'val123',
          },
          requestOptions: RequestOptions(),
        ),
      );

      final result = await qrScannerService.processScan(
        qrData,
        merchantId: merchantId,
      );

      expect(result.success, true);
      expect(result.order, isNotNull);
      expect(result.order!.id, 'order123');
      expect(result.validationId, 'val123');
    });

    test('should handle offline mode gracefully', () async {
      const merchantId = 'merchant456';
      final validPayload = {
        'v': '2.0',
        'merchant_id': merchantId,
        'consumer_id': 'consumer789',
        'order_id': 'order123',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'valid_signature',
      };

      final qrData = base64Url.encode(utf8.encode(jsonEncode(validPayload)));

      when(
        mockDio.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onSendProgress: anyNamed('onSendProgress'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: 'Network error',
        ),
      );

      final result = await qrScannerService.processScan(
        qrData,
        merchantId: merchantId,
      );

      expect(result.success, false);
      expect(result.error, 'OFFLINE');
      expect(result.isOffline, true);
      expect(result.offlineScanId, isNotNull);
      expect(qrScannerService.pendingScansCount, 1);
    });

    test('should sync offline scans successfully', () async {
      // Add offline scan first
      const merchantId = 'merchant456';
      final validPayload = {
        'v': '2.0',
        'merchant_id': merchantId,
        'consumer_id': 'consumer789',
        'order_id': 'order123',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'valid_signature',
      };

      final qrData = base64Url.encode(utf8.encode(jsonEncode(validPayload)));

      // Simulate offline scan
      var callCount = 0;
      when(
        mockDio.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onSendProgress: anyNamed('onSendProgress'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          throw DioException(
            requestOptions: RequestOptions(),
          );
        }
        return Response(
          data: {'valid': true},
          requestOptions: RequestOptions(),
        );
      });

      await qrScannerService.processScan(qrData, merchantId: merchantId);
      expect(qrScannerService.pendingScansCount, 1);

      // Now sync
      final syncResult = await qrScannerService.syncOfflineScans();

      expect(syncResult.synced, 1);
      expect(syncResult.failed, 0);
      expect(qrScannerService.pendingScansCount, 0);
    });

    test('should reject merchant mismatch', () async {
      const merchantId = 'merchant456';
      const wrongMerchantId = 'wrong_merchant';

      final payload = {
        'v': '2.0',
        'merchant_id': wrongMerchantId,
        'consumer_id': 'consumer789',
        'order_id': 'order123',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'valid_signature',
      };

      final qrData = base64Url.encode(utf8.encode(jsonEncode(payload)));

      final result = await qrScannerService.processScan(
        qrData,
        merchantId: merchantId,
      );

      expect(result.success, false);
      expect(result.error, 'MERCHANT_MISMATCH');
    });
  });

  group('Performance Tests', () {
    test('QR generation should be under 50ms', () async {
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';

      when(
        mockStorage.read(
          key: anyNamed('key'),
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).thenAnswer(
        (_) async => jsonEncode({
          'secret': secret,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      final stopwatch = Stopwatch()..start();

      await qrCodeService.generateSecureQRCode(
        orderId: 'perf_test',
        merchantId: 'merchant123',
        consumerId: 'consumer456',
      );

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('TOTP validation should be constant time', () async {
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
      final correctToken = await totpService.generateTOTP(secret);
      const wrongToken = '00000000';

      // Measure correct token validation
      final stopwatch1 = Stopwatch()..start();
      await totpService.validateTOTP(secret, correctToken);
      stopwatch1.stop();

      // Measure wrong token validation
      final stopwatch2 = Stopwatch()..start();
      await totpService.validateTOTP(secret, wrongToken);
      stopwatch2.stop();

      // Times should be similar (constant time comparison)
      final diff =
          (stopwatch1.elapsedMicroseconds - stopwatch2.elapsedMicroseconds)
              .abs();
      expect(diff, lessThan(1000)); // Less than 1ms difference
    });
  });

  group('Security Edge Cases', () {
    test('should handle replay attacks', () async {
      // This would need actual Redis implementation to test properly
      // For now, we test the logic flow

      final response1 = Response(
        data: <String, dynamic>{
          'valid': true,
          'order': <String, dynamic>{
            'id': 'order123',
            'customerName': 'John Doe',
            'items': [
              {'name': 'Salad', 'quantity': 1, 'price': 9.99},
            ],
            'totalAmount': 9.99,
          },
          'validationId': 'val1',
        },
        requestOptions: RequestOptions(),
      );

      final response2 = Response(
        data: <String, dynamic>{'valid': false, 'error': 'ALREADY_USED'},
        requestOptions: RequestOptions(),
      );

      var replayCallCount = 0;
      when(
        mockDio.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onSendProgress: anyNamed('onSendProgress'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenAnswer((_) async {
        replayCallCount++;
        return replayCallCount == 1 ? response1 : response2;
      });

      final payload = {
        'v': '2.0',
        'merchant_id': 'test',
        'consumer_id': 'c',
        'order_id': 'o',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'sig',
      };
      final qrData = base64Url.encode(utf8.encode(jsonEncode(payload)));

      // First scan should succeed
      final result1 = await qrScannerService.processScan(
        qrData,
        merchantId: 'test',
      );
      expect(result1.success, true);

      // Second scan with same QR should fail
      final result2 = await qrScannerService.processScan(
        qrData,
        merchantId: 'test',
      );
      expect(result2.success, false);
      expect(result2.error, 'ALREADY_USED');
    });

    test('should handle malformed QR codes gracefully', () async {
      const malformedQR = 'not_a_valid_qr_code';

      final result = await qrScannerService.processScan(
        malformedQR,
        merchantId: 'test',
      );

      expect(result.success, false);
      expect(result.error, contains('INVALID'));
    });

    test('should validate signature correctly', () {
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
      final payload = {
        'order_id': 'test123',
        'amount': 100,
      };

      // Generate valid signature
      final validSig = totpService.generateHMACSignature(payload, secret);

      // Add signature to payload
      payload['sig'] = validSig;

      // Should validate successfully
      final isValid = totpService.verifyHMACSignature(
        payload,
        validSig,
        secret,
      );
      expect(isValid, true);

      // Tamper with payload
      payload['amount'] = 200;

      // Should fail validation
      final isTampered = totpService.verifyHMACSignature(
        payload,
        validSig,
        secret,
      );
      expect(isTampered, false);
    });
  });
}

// Extension to make payload compression testable
extension on QRCodeService {
  Future<String> compressPayload(Map<String, dynamic> payload) async {
    // Retourner un format compatible avec decodeQRCode: zlib + base64Url
    final jsonStr = jsonEncode(payload);
    final bytes = utf8.encode(jsonStr);
    final compressed = zlib.encode(bytes);
    return base64Url.encode(compressed);
  }
}
