import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/logging/data/LogAdatper.dart';
import 'package:grocery_brasil_app/features/logging/domain/LogMessage.dart';
import 'package:grocery_brasil_app/features/logging/domain/LogService.dart';
import 'package:mockito/mockito.dart';

class MockLogAdapter extends Mock implements LogAdapter {}

main() {
  LogServiceImpl sut;
  MockLogAdapter mockLogAdapter;

  setUp(() {
    mockLogAdapter = MockLogAdapter();
    sut = LogServiceImpl(logAdapter: mockLogAdapter);
  });

  test('Should log to the log system', () async {
    final logMessage = LogMessage(
      Level.DEBUG,
      "This is a mask with this {} and this {} and this {} information",
      List.of({"some string", 123, true}),
    );
    when(mockLogAdapter.log(logMessage))
        .thenAnswer((realInvocation) async => null);
    await sut.log(logMessage);
    verify(mockLogAdapter.log(logMessage)).called(1);
  });
  test('Should initialize the log system', () async {
    final someUser = User(email: 'someEmail', userId: 'someUserId');
    when(mockLogAdapter.initializeLog(someUser))
        .thenAnswer((realInvocation) async => null);
    await sut.initializeLog(someUser);
    verify(mockLogAdapter.initializeLog(someUser)).called(1);
  });
}
