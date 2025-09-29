import 'package:dio/dio.dart';
import 'package:ecoplates/core/services/qr_security_config_service.dart';
import 'package:ecoplates/core/services/time_sync_service.dart';
import 'package:ecoplates/core/services/totp_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'qr_security_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late MockLoggerService mockLogger;
  late TimeSyncService timeSyncService;
  late QRSecurityConfigService configService;
  late TOTPService totpService;

  setUp(() {
    mockDio = MockDio();
    mockLogger = MockLoggerService();

    // Forcer config défaut (échec réseau)
    when(
      mockDio.get<Map<String, dynamic>>(any),
    ).thenThrow(DioException(requestOptions: RequestOptions()));

    timeSyncService = TimeSyncService(dio: mockDio, logger: mockLogger);
    configService = QRSecurityConfigService(dio: mockDio, logger: mockLogger);
    totpService = TOTPService(
      timeSyncService: timeSyncService,
      configService: configService,
      logger: mockLogger,
    );
  });

  test('computeQRHash retourne un hash base64url stable', () {
    const data = 'qr_data_example';
    final h1 = totpService.computeQRHash(data);
    final h2 = totpService.computeQRHash(data);

    expect(h1, isNotEmpty);
    expect(h1, h2);
  });

  test('getProgressPercentage renvoie une valeur entre 0 et 1', () async {
    final p = await totpService.getProgressPercentage();
    expect(p, inInclusiveRange(0.0, 1.0));
  });
}
