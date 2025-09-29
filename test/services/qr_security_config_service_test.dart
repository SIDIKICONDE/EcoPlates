import 'package:dio/dio.dart';
import 'package:ecoplates/core/services/qr_security_config_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'qr_security_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late MockLoggerService mockLogger;
  late QRSecurityConfigService configService;

  setUp(() {
    mockDio = MockDio();
    mockLogger = MockLoggerService();
    configService = QRSecurityConfigService(dio: mockDio, logger: mockLogger);
  });

  test("fallback configuration par défaut en cas d'erreur réseau", () async {
    when(
      mockDio.get<Map<String, dynamic>>('/api/v1/qr/config'),
    ).thenThrow(DioException(requestOptions: RequestOptions()));

    final cfg = await configService.getConfiguration();
    expect(cfg.protocolVersion, '2.0');
    expect(cfg.totpDigits, 8);
  });

  test('offline limits calculés correctement', () async {
    when(mockDio.get<Map<String, dynamic>>('/api/v1/qr/config')).thenAnswer(
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

    final cfg = await configService.getConfiguration();
    final limits = configService.getOfflineLimits(cfg);
    expect(limits.maxDuration.inHours, 24);
    expect(limits.maxGenerations, (24 * 3600) ~/ 30);
  });
}
