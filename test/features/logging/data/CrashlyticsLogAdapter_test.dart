import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/logging/data/CrashlyticsLogAdapter.dart';
import 'package:grocery_brasil_app/features/logging/domain/LogMessage.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

main() {
  CrashlyticsLogAdapter sut;
  MockFirebaseCrashlytics mockFirebaseCrashlytics;

  setUp(() {
    mockFirebaseCrashlytics = MockFirebaseCrashlytics();
    sut = CrashlyticsLogAdapter(firebaseCrashlytics: mockFirebaseCrashlytics);
  });

  test('Should log to the log system', () async {
    final logMessage = LogMessage(
      Level.DEBUG,
      "string (%s), number(%d) boolean(%s)",
      List.of({"some string", 123, true}),
    );
    when(mockFirebaseCrashlytics
            .log("string (some string), number(123) boolean(true)"))
        .thenAnswer((realInvocation) async => null);
    await sut.log(logMessage);
    verify(mockFirebaseCrashlytics
            .log("string (some string), number(123) boolean(true)"))
        .called(1);
  });
}
