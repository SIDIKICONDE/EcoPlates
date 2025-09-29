import 'package:ecoplates/core/services/time_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'qr_security_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late MockLoggerService mockLogger;
  late TimeSyncService timeSync;

  setUp(() {
    mockDio = MockDio();
    mockLogger = MockLoggerService();
    timeSync = TimeSyncService(dio: mockDio, logger: mockLogger);
  });

  test("invalidateSync remet l'offset et le flag needsSync", () {
    timeSync.applyManualOffset(const Duration(milliseconds: 1234));
    expect(timeSync.needsSync, false);

    timeSync.invalidateSync();
    expect(timeSync.needsSync, true);
  });
}
