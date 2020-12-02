import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/domain/UserPreferences.dart';
import 'package:grocery_brasil_app/features/user/domain/CreateUserUseCase.dart';
import 'package:grocery_brasil_app/features/user/domain/GetUserUseCase.dart';
import 'package:grocery_brasil_app/features/user/domain/UpdateUserUseCase.dart';
import 'package:grocery_brasil_app/features/user/domain/UserService.dart';
import 'package:mockito/mockito.dart';

class MockUserService extends Mock implements UserService {}

main() {
  MockUserService mockUserService;
  group('UserUseCase', () {
    setUp(() {
      mockUserService = MockUserService();
    });
    group('CreateUserUseCase', () {
      UseCase<User, User> sut;
      setUp(() {
        sut = CreateUserUseCase(mockUserService);
      });
      test('should call  UserService.createUser', () async {
        //setup
        final expected = User(
            email: 'test@test.com',
            userId: 'someUserId',
            address: Address(rawAddress: 'someRawAddress'),
            preferences: UserPreferences(searchRadius: 30000));
        final someUser = User(email: 'test@test.com', userId: 'someUserId');
        when(mockUserService.createUser(someUser))
            .thenAnswer((realInvocation) async => Right(expected));

        //act
        final actual = await sut(someUser);

        //assert
        expect(actual, Right(expected));
      });
    });
    group('Update User useCase', () {
      UseCase<User, User> sut;
      setUp(() {
        sut = UpdateUserUseCase(mockUserService);
      });

      test('should call  UserService.update', () async {
        //setup
        final expected = User(
            email: 'test@test.com',
            userId: 'someUserId',
            address: Address(rawAddress: 'someRawAddress'),
            preferences: UserPreferences(searchRadius: 30000));
        final someUser = User(email: 'test@test.com', userId: 'someUserId');
        when(mockUserService.updateUser(someUser))
            .thenAnswer((realInvocation) async => Right(expected));

        //act
        final actual = await sut(someUser);

        //assert
        expect(actual, Right(expected));
      });
    });

    group('Get User useCase', () {
      UseCase<User, NoParams> sut;
      setUp(() {
        sut = GetUserUseCase(userService: mockUserService);
      });

      test('should call  UserService.update', () async {
        //setup
        final expected = User(
            email: 'test@test.com',
            userId: 'someUserId',
            address: Address(rawAddress: 'someRawAddress'),
            preferences: UserPreferences(searchRadius: 30000));
        when(mockUserService.getUser())
            .thenAnswer((realInvocation) async => Right(expected));

        //act
        final actual = await sut(NoParams());

        //assert
        expect(actual, Right(expected));
      });
    });
  });
}
