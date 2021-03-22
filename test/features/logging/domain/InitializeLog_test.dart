import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/logging/domain/InitializeLog.dart';
import 'package:grocery_brasil_app/features/logging/domain/LogService.dart';
import 'package:mockito/mockito.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  InitializeLog sut;
  MockLogService mockLogService;

  setUp(() {
    mockLogService = MockLogService();
    sut = InitializeLog(logService: mockLogService);
  });

  test('Should initialize the log system', () async {
    final someUser = User(email: 'someEmail', userId: 'someUserId');
    when(mockLogService.initializeLog(someUser))
        .thenAnswer((realInvocation) async => null);
    final actual = await sut.call(someUser);
    expect(actual.isRight(), true);
  });
  test('Should return failure if it fails', () async {
    final someUser = User(email: 'someEmail', userId: 'someUserId');
    final expected = LoggingFailure(
        messageId: MessageIds.UNEXPECTED, message: 'Exception: error');
    when(mockLogService.initializeLog(someUser)).thenThrow(Exception('error'));
    final actual = await sut.call(someUser);
    expect(actual, Left(expected));
  });
}
