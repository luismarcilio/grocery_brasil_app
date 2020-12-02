import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/domain/UserPreferences.dart';
import 'package:grocery_brasil_app/features/login/domain/repositories/AuthenticationRepository.dart';
import 'package:grocery_brasil_app/features/user/domain/UserRepository.dart';
import 'package:grocery_brasil_app/features/user/domain/UserService.dart';
import 'package:grocery_brasil_app/features/user/domain/UserServiceImpl.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

main() {
  MockUserRepository mockUserRepository;
  MockAuthenticationRepository mockAuthenticationRepository;
  UserService sut;
  group('UserService', () {
    setUp(() {
      mockUserRepository = MockUserRepository();
      mockAuthenticationRepository = MockAuthenticationRepository();
      sut = UserServiceImpl(
          userRepository: mockUserRepository,
          authenticationRepository: mockAuthenticationRepository);
    });
    group('createUser', () {
      test('should create user when it does not exist', () async {
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
        final actual = await sut.createUser(someUser);

        //assert
        expect(actual, Right(expected));
        verify(mockUserRepository.getUserByUserId(someUser.userId));
        verify(mockUserRepository.createUser(someUser));
        verifyNoMoreInteractions(mockUserRepository);
      });
      test('should skip creation when user exists', () async {
        //setup
        final someUser = User(
            email: 'test@test.com',
            userId: 'someUserId',
            address: Address(rawAddress: 'someRawAddress'),
            preferences: UserPreferences(searchRadius: 30000));
        when(mockUserRepository.getUserByUserId(someUser.userId))
            .thenAnswer((realInvocation) async => Right(someUser));

        //act
        final actual = await sut.createUser(someUser);

        //assert
        expect(actual, Right(someUser));
        verify(mockUserRepository.getUserByUserId(someUser.userId));
        verifyNoMoreInteractions(mockUserRepository);
      });
      test('should return UserFailure when it fails', () async {
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
        final actual = await sut.createUser(someUser);
        actual.fold((l) => print(l.message), (r) => null);

        //assert
        expect(actual, Left(expected));
        verify(mockUserRepository.getUserByUserId(someUser.userId));
        verifyNoMoreInteractions(mockUserRepository);
      });
    });

    group('getUser', () {
      test('should return current user ', () async {
        //setup
        final expected = User(
            email: 'test@test.com',
            userId: 'someUserId',
            address: Address(rawAddress: 'someRawAddress'),
            preferences: UserPreferences(searchRadius: 30000));
        when(mockAuthenticationRepository.getUserId())
            .thenAnswer((realInvocation) async => Right('someUserId'));
        when(mockUserRepository.getUserByUserId('someUserId'))
            .thenAnswer((realInvocation) async => Right(expected));
        //act
        final actual = await sut.getUser();
        //assert
        expect(actual, Right(expected));
      });
      test('should return UserFailure when it fails', () async {
        //setup
        final expected = UserFailure(
            messageId: MessageIds.UNEXPECTED, message: "Exception: error");
        when(mockAuthenticationRepository.getUserId())
            .thenAnswer((realInvocation) async => Right('someUserId'));
        when(mockUserRepository.getUserByUserId('someUserId'))
            .thenAnswer((realInvocation) async => Left(expected));
        //act
        final actual = await sut.getUser();

        //assert
        expect(actual, Left(expected));
      });
      test('should return UserFailure  when some exception occurs', () async {
        final expected = UserFailure(
            messageId: MessageIds.UNEXPECTED, message: "Exception: some error");
        when(mockAuthenticationRepository.getUserId())
            .thenThrow(Exception('some error'));
        //act
        final actual = await sut.getUser();

        //assert
        expect(actual, Left(expected));
      });
    });
    group('updateUser', () {
      test('should update the user ', () async {
        //setup
        User someUser = User(userId: 'someId', email: 'someEmail');
        User expected = User(userId: 'someId', email: 'someEmail');
        when(mockUserRepository.updateUser(someUser))
            .thenAnswer((realInvocation) async => Right(expected));
        //act
        final actual = await sut.updateUser(someUser);
        //assert
        expect(actual, Right(expected));
        verify(mockUserRepository.updateUser(someUser));
        verifyNoMoreInteractions(mockUserRepository);
      });
      test('should return UserFailure when it fails', () async {
        //setup
        final someUser = User(userId: 'someId', email: 'someEmail');
        final exception = Exception('error');
        final expected = UserFailure(
            messageId: MessageIds.UNEXPECTED, message: "Exception: error");
        when(mockUserRepository.updateUser(someUser)).thenThrow(exception);
        //act
        final actual = await sut.updateUser(someUser);

        //assert
        expect(actual, Left(expected));
      });
    });
  });
}
