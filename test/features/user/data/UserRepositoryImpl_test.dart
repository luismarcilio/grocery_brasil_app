import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/domain/UserPreferences.dart';
import 'package:grocery_brasil_app/features/addressing/data/AddressingDataSource.dart';
import 'package:grocery_brasil_app/features/user/data/UserDataSource.dart';
import 'package:grocery_brasil_app/features/user/data/UserRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/user/domain/UserRepository.dart';
import 'package:mockito/mockito.dart';

class MockUserDataSource extends Mock implements UserDataSource {}

class MockAddressingDataSource extends Mock implements AddressingDataSource {}

main() {
  MockUserDataSource mockUserDataSource;
  MockAddressingDataSource mockAddressingDataSource;
  UserRepository sut;
  setUp(() {
    mockUserDataSource = MockUserDataSource();
    mockAddressingDataSource = MockAddressingDataSource();

    sut = UserRepositoryImpl(
        userDataSource: mockUserDataSource,
        addressingDataSource: mockAddressingDataSource);
  });
  group('UserRepository', () {
    group('createUser', () {
      test('should create user ', () async {
        //setup
        final someUser = User(userId: 'someUserId', email: 'someEmail');
        final expectedCurrentLocation =
            Address(rawAddress: 'someRawAddress', street: 'some Street');
        final expected = User(
          userId: someUser.userId,
          email: someUser.email,
          address: expectedCurrentLocation,
          preferences: UserPreferences(searchRadius: 30000),
        );
        when(mockAddressingDataSource.getCurrentAddress())
            .thenAnswer((realInvocation) async => expectedCurrentLocation);
        when(mockUserDataSource.createUser(expected))
            .thenAnswer((realInvocation) async => expected);

        //act
        final actual = await sut.createUser(someUser);
        //assert
        expect(actual, Right(expected));
        verify(mockAddressingDataSource.getCurrentAddress());
        verifyNoMoreInteractions(mockAddressingDataSource);

        verify(mockUserDataSource.createUser(expected));
        verifyNoMoreInteractions(mockUserDataSource);
      });

      test('should return Left<UserFailure> if some error occurs ', () async {
        //setup
        final someUser = User(userId: 'someUserId', email: 'someEmail');
        final expected = UserFailure(
            messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
        when(mockAddressingDataSource.getCurrentAddress())
            .thenThrow(Exception('some error'));

        //act
        final actual = await sut.createUser(someUser);
        //assert
        expect(actual, Left(expected));
      });
    });
    group('getUserByUserId', () {
      test('should get the user ', () async {
        //setup
        final expected = User(userId: 'someUserId', email: 'someEmail');
        when(mockUserDataSource.getUserByUserId(expected.userId))
            .thenAnswer((realInvocation) async => expected);

        //act
        final actual = await sut.getUserByUserId(expected.userId);
        //assert
        expect(actual, Right(expected));
        verify(mockUserDataSource.getUserByUserId(expected.userId));
        verifyNoMoreInteractions(mockUserDataSource);
      });

      test('should return Left<UserException> when an error occurs', () async {
        //setup
        final expected = UserFailure(
            messageId: MessageIds.UNEXPECTED,
            message: 'Exception: Some error happened');
        when(mockUserDataSource.getUserByUserId('SomeUserId'))
            .thenThrow(Exception('Some error happened'));
        //act
        final actual = await sut.getUserByUserId('SomeUserId');

        //assert
        expect(actual, Left(expected));
      });
    });

    group('updateUser', () {
      test('should update user ', () async {
        //setup
        final someUser = User(userId: 'someUserId', email: 'someEmail');
        final expected = User(userId: 'someUserId', email: 'someEmail');
        when(mockUserDataSource.updateUser(someUser))
            .thenAnswer((realInvocation) async => expected);

        //act
        final actual = await sut.updateUser(someUser);
        //assert
        expect(actual, Right(expected));
        verify(mockUserDataSource.updateUser(someUser));
        verifyNoMoreInteractions(mockUserDataSource);
      });
      test('should return UserFailure when some exception occurs', () async {
        //setup
        final someUser = User(userId: 'someUserId', email: 'someEmail');
        final expected = UserFailure(
            messageId: MessageIds.UNEXPECTED,
            message: 'Exception: Some error happened');
        when(mockUserDataSource.updateUser(someUser))
            .thenThrow(Exception('Some error happened'));
        //act
        final actual = await sut.updateUser(someUser);
        //assert
        expect(actual, Left(expected));
      });
    });
  });
}
