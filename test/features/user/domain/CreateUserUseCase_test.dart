import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/user/domain/CreateUserUseCase.dart';
import 'package:grocery_brasil_app/features/user/domain/UserRepository.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

main() {
  MockUserRepository mockUserRepository = MockUserRepository();
  group('CreateUserUseCase', () {
    UseCase<User, User> sut = CreateUserUseCase(mockUserRepository);
    test('should create user if it doesn\'t exist ', () async {
      //setup
      final expected = User(
          email: 'test@test.com',
          userId: 'someUserId',
          address: Address(rawAddress: 'someRawAddress'),
          preferences: UserPreferences(searchRadius: 30000));
      final someUser = User(email: 'test@test.com', userId: 'someUserId');
      when(mockUserRepository.getUserByUserId(someUser.userId)).thenAnswer(
          (realInvocation) async =>
              Left(UserFailure(messageId: MessageIds.NOT_FOUND)));
      when(mockUserRepository.createUser(someUser))
          .thenAnswer((realInvocation) async => Right(expected));

      //act
      final actual = await sut(someUser);

      //assert
      expect(actual, Right(expected));
      verify(mockUserRepository.getUserByUserId(someUser.userId));
      verify(mockUserRepository.createUser(someUser));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should skip creation when user exists ', () async {
      //setup
      final someUser = User(
          email: 'test@test.com',
          userId: 'someUserId',
          address: Address(rawAddress: 'someRawAddress'),
          preferences: UserPreferences(searchRadius: 30000));
      when(mockUserRepository.getUserByUserId(someUser.userId))
          .thenAnswer((realInvocation) async => Right(someUser));

      //act
      final actual = await sut(someUser);

      //assert
      expect(actual, Right(someUser));
      verify(mockUserRepository.getUserByUserId(someUser.userId));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return UserFailure if some error occurs ', () async {
      //setup
      final someUser = User(
          email: 'test@test.com',
          userId: 'someUserId',
          address: Address(rawAddress: 'someRawAddress'),
          preferences: UserPreferences(searchRadius: 30000));
      final expected = UserFailure(
          messageId: MessageIds.UNEXPECTED,
          message: 'Exception: Some error happened');
      when(mockUserRepository.getUserByUserId(someUser.userId))
          .thenThrow(Exception('Some error happened'));

      //act
      final actual = await sut(someUser);
      actual.fold((l) => print(l.message), (r) => null);

      //assert
      expect(actual, Left(expected));
      verify(mockUserRepository.getUserByUserId(someUser.userId));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}
