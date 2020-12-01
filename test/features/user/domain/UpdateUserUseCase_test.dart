import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/user/domain/UpdateUserUseCase.dart';
import 'package:grocery_brasil_app/features/user/domain/UserRepository.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

main() {
  MockUserRepository mockUserRepository;
  UpdateUserUseCase sut;

  group('UpdateUserUseCase', () {
    setUp(() {
      mockUserRepository = MockUserRepository();
      sut = UpdateUserUseCase(mockUserRepository);
    });

    test('should call update user ', () async {
      //setup
      User someUser = User(userId: 'someId', email: 'someEmail');
      User expected = User(userId: 'someId', email: 'someEmail');
      when(mockUserRepository.updateUser(someUser))
          .thenAnswer((realInvocation) async => Right(expected));
      //act
      final actual = await sut(someUser);
      //assert
      expect(actual, Right(expected));
      verify(mockUserRepository.updateUser(someUser));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return UserFailure when an exception occurs', () async {
      //setup
      final someUser = User(userId: 'someId', email: 'someEmail');
      final exception = Exception('error');
      final expected = UserFailure(
          messageId: MessageIds.UNEXPECTED, message: "Exception: error");
      when(mockUserRepository.updateUser(someUser)).thenThrow(exception);
      //act
      final actual = await sut(someUser);

      //assert
      expect(actual, Left(expected));
    });
  });
}
