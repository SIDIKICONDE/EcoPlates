import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecoplates/core/services/qr_code_service.dart';
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

  late SecureStorageService secureStorageService;
  late TimeSyncService timeSyncService;
  late QRSecurityConfigService configService;
  late TOTPService totpService;
  late QRCodeService qrCodeService;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockDio = MockDio();
    mockLogger = MockLoggerService();

    // Forcer la config à utiliser les valeurs par défaut (erreur réseau simulée)
    when(
      mockDio.get<Map<String, dynamic>>(any, options: anyNamed('options')),
    ).thenThrow(DioException(requestOptions: RequestOptions()));

    secureStorageService = SecureStorageService(
      storage: mockStorage,
      logger: mockLogger,
    );

    timeSyncService = TimeSyncService(
      dio: mockDio,
      logger: mockLogger,
    );

    configService = QRSecurityConfigService(
      dio: mockDio,
      logger: mockLogger,
    );

    totpService = TOTPService(
      timeSyncService: timeSyncService,
      configService: configService,
      logger: mockLogger,
    );

    qrCodeService = QRCodeService(
      secureStorage: secureStorageService,
      totpService: totpService,
      configService: configService,
      timeSyncService: timeSyncService,
      logger: mockLogger,
    );
  });

  group('QRCodeService - génération/décodage/validation', () {
    test('génère un QR sécurisé avec un payload complet', () async {
      const orderId = 'order_001';
      const merchantId = 'merchant_abc';
      const consumerId = 'consumer_xyz';
      const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';

      // Le service stocke/charge la clé sous 'order_secret_<orderId>'
      when(
        mockStorage.read(
          key: 'order_secret_$orderId',
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).thenAnswer(
        (_) async => jsonEncode({
          'secret': secret,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      final qr = await qrCodeService.generateSecureQRCode(
        orderId: orderId,
        merchantId: merchantId,
        consumerId: consumerId,
      );

      expect(qr.orderId, orderId);
      expect(qr.rawData, isNotEmpty);
      expect(qr.payload['v'], '2.0');
      expect(qr.payload['merchant_id'], merchantId);
      expect(qr.payload['consumer_id'], consumerId);
      expect(qr.payload['order_id'], orderId);
      expect(qr.payload['token'], isA<String>());
      expect(qr.payload['sig'], isA<String>());
    });

    test('decodeQRCode décompresse et retourne le payload', () async {
      final payload = {
        'v': '2.0',
        'merchant_id': 'm1',
        'consumer_id': 'c1',
        'order_id': 'o1',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'signature',
      };

      final qrData = _compress(payload);
      final decoded = await qrCodeService.decodeQRCode(qrData);

      expect(decoded, isNotNull);
      expect(decoded!['merchant_id'], 'm1');
      expect(decoded['order_id'], 'o1');
    });

    test('validateQRCodeLocally accepte un QR valide et récent', () async {
      final payload = {
        'v': '2.0',
        'merchant_id': 'm2',
        'consumer_id': 'c2',
        'order_id': 'o2',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '87654321',
        'sig': 'signature',
      };

      final qrData = _compress(payload);
      final result = await qrCodeService.validateQRCodeLocally(qrData);

      expect(result.isValid, true);
      expect(result.payload, isNotNull);
    });

    test('validateQRCodeLocally rejette un QR expiré', () async {
      final payload = {
        'v': '2.0',
        'merchant_id': 'm3',
        'consumer_id': 'c3',
        'order_id': 'o3',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 2))
            .millisecondsSinceEpoch,
        'token': '00000000',
        'sig': 'signature',
      };

      final qrData = _compress(payload);
      final result = await qrCodeService.validateQRCodeLocally(qrData);

      expect(result.isValid, false);
      expect(result.error, 'EXPIRED');
    });

    test(
      'decodeQRCode accepte aussi le JSON non compressé (fallback)',
      () async {
        final payload = {
          'v': '2.0',
          'merchant_id': 'm1',
          'consumer_id': 'c1',
          'order_id': 'o1',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'token': '12345678',
          'sig': 'signature',
        };

        final base64Json = base64Url.encode(utf8.encode(jsonEncode(payload)));
        final decoded = await qrCodeService.decodeQRCode(base64Json);

        expect(decoded, isNotNull);
        expect(decoded!['consumer_id'], 'c1');
      },
    );

    test('validateQRCodeLocally détecte version protocole invalide', () async {
      final payload = {
        'v': '1.0',
        'merchant_id': 'm1',
        'consumer_id': 'c1',
        'order_id': 'o1',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        'sig': 'signature',
      };

      final qrData = _compress(payload);
      final result = await qrCodeService.validateQRCodeLocally(qrData);

      expect(result.isValid, false);
      expect(result.error, 'INVALID_FORMAT');
    });

    test('validateQRCodeLocally signale champ manquant', () async {
      final payload = {
        'v': '2.0',
        'merchant_id': 'm1',
        'consumer_id': 'c1',
        'order_id': 'o1',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'token': '12345678',
        // 'sig' manquant
      };

      final qrData = _compress(payload);
      final result = await qrCodeService.validateQRCodeLocally(qrData);

      expect(result.isValid, false);
      expect(result.error, 'MISSING_FIELD');
    });
  });

  group('QRCodeService - révocation de secrets', () {
    test('révocation globale supprime le secret principal', () async {
      const orderId = 'order123';

      // getConfiguration => défaut
      when(
        mockDio.get<Map<String, dynamic>>(any),
      ).thenThrow(DioException(requestOptions: RequestOptions()));

      // Attendre delete sous-jacent
      when(
        mockStorage.delete(
          key: 'order_secret_$orderId',
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).thenAnswer((_) async {});

      await qrCodeService.revokeSecret(orderId);

      verify(
        mockStorage.delete(
          key: 'order_secret_$orderId',
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).called(1);
    });

    test('révocation granulaire supprime le secret lié au device', () async {
      const orderId = 'ordX';
      const deviceId = 'devY';

      // Config avec révocation granulaire activée
      when(
        mockDio.get<Map<String, dynamic>>('/api/v1/qr/config'),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'totpWindowSteps': 1,
            'totpPeriodSeconds': 30,
            'totpDigits': 8,
            'maxOfflineHours': 24,
            'qrExpirationSeconds': 30,
            'enableDeviceBinding': false,
            'enableGranularRevocation': true,
            'maxFailedAttempts': 5,
            'alertThreshold': 3,
            'compressionEnabled': true,
            'protocolVersion': '2.0',
          },
          requestOptions: RequestOptions(),
        ),
      );

      when(
        mockStorage.delete(
          key: 'order_secret_${orderId}_$deviceId',
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).thenAnswer((_) async {});

      await qrCodeService.revokeSecret(orderId, deviceId: deviceId);

      verify(
        mockStorage.delete(
          key: 'order_secret_${orderId}_$deviceId',
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
        ),
      ).called(1);
    });
  });
}

String _compress(Map<String, dynamic> payload) {
  final jsonStr = jsonEncode(payload);
  final bytes = utf8.encode(jsonStr);
  final compressed = zlib.encode(bytes);
  return base64Url.encode(compressed);
}
