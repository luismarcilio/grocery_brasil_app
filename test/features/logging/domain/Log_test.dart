import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/logging/domain/Log.dart';
import 'package:grocery_brasil_app/features/logging/domain/LogMessage.dart';
import 'package:grocery_brasil_app/features/logging/domain/LogService.dart';
import 'package:mockito/mockito.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  Log sut;
  MockLogService mockLogService;

  setUp(() {
    mockLogService = MockLogService();
    sut = Log(logService: mockLogService);
  });

  test('Should log to the log system', () async {
    final logMessage = LogMessage(
      Level.DEBUG,
      "This is a mask with this {} and this {} and this {} information",
      List.of({"some string", 123, true}),
    );
    when(mockLogService.log(logMessage))
        .thenAnswer((realInvocation) async => null);
    final actual = await sut.call(logMessage);
    expect(actual.isRight(), true);
  });
  test('Should return failure if it fails', () async {
    final logMessage = LogMessage(
      Level.DEBUG,
      "This is a mask with this {} and this {} and this {} information",
      List.of({"some string", 123, true}),
    );
    final expected = LoggingFailure(
        messageId: MessageIds.UNEXPECTED, message: 'Exception: error');
    when(mockLogService.log(logMessage)).thenThrow(Exception('error'));
    final actual = await sut.call(logMessage);
    expect(actual, Left(expected));
  });
}
