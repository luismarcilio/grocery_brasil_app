import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/domain/UserPreferences.dart';
import 'package:grocery_brasil_app/features/addressing/data/AddressingDataSource.dart';
import 'package:grocery_brasil_app/features/login/domain/repositories/AuthenticationRepository.dart';
import 'package:grocery_brasil_app/features/login/domain/service/AuthenticationService.dart';
import 'package:grocery_brasil_app/features/login/domain/service/AuthenticationServiceImpl.dart';
import 'package:grocery_brasil_app/features/user/domain/UserService.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAddressingDataSource extends Mock implements AddressingDataSource {}

class MockUserService extends Mock implements UserService {}

void main() {
  MockAuthenticationRepository mockAuthenticationRepository;
  MockAddressingDataSource mockAddressingDataSource;
  MockUserService mockUserService;
  AuthenticationService sut;

  group('AuthenticationServiceImpl', () {
    setUp(() {
      mockAuthenticationRepository = MockAuthenticationRepository();
      mockAddressingDataSource = MockAddressingDataSource();
      mockUserService = MockUserService();
      sut = AuthenticationServiceImpl(
          authenticationRepository: mockAuthenticationRepository,
          addressingDataSource: mockAddressingDataSource,
          userService: mockUserService);
    });

    final User authenticatedUser =
        User(email: 'test@email.com', userId: '1', emailVerified: true);

    group('Authenticate with google', () {
      test('Should authenticateWithGoogle and create user if does not exist',
          () async {
        //Setup
        when(mockAuthenticationRepository.authenticateWithGoogle())
            .thenAnswer((realInvocation) async => Right(authenticatedUser));
        when(mockUserService.getUser()).thenAnswer((realInvocation) async =>
            Left(UserFailure(messageId: MessageIds.NOT_FOUND)));
        when(mockAddressingDataSource.getCurrentAddress()).thenAnswer(
            (realInvocation) async => Address(rawAddress: 'some address'));
        final expectedUser = User(
            email: authenticatedUser.email,
            userId: authenticatedUser.userId,
            emailVerified: authenticatedUser.emailVerified,
            address: Address(rawAddress: 'some address'),
            preferences: UserPreferences(searchRadius: 30000));
        when(mockUserService.createUser(expectedUser))
            .thenAnswer((realInvocation) async => Right(expectedUser));
        //Act
        final actual = await sut.authenticateWithGoogle();
        //Assert
        expect(actual, Right(expectedUser));
        verify(mockAuthenticationRepository.authenticateWithGoogle());
        verifyNoMoreInteractions(mockAuthenticationRepository);
        verify(mockUserService.getUser());
        verify(mockUserService.createUser(expectedUser));
        verifyNoMoreInteractions(mockUserService);
        verify(mockAddressingDataSource.getCurrentAddress());
        verifyNoMoreInteractions(mockAddressingDataSource);
      });

      test('Should catch  AuthenticationException', () async {
        //Setup
        when(mockAuthenticationRepository.authenticateWithGoogle()).thenThrow(
            AuthenticationException(
                messageId: MessageIds.UNEXPECTED, message: "erro"));
        //Act
        final actual = await sut.authenticateWithGoogle();
        expect(
            actual,
            equals(Left(AuthenticationFailure(
                messageId: MessageIds.UNEXPECTED,
                message: 'AuthenticationException'))));
      });
    });

    // group('Authenticate with facebook', () {
    //   test('Should call authenticateWithFacebook', () async {
    //     //Setup
    //     when(mockAuthenticationDataSource.authenticateWithFacebook())
    //         .thenAnswer((realInvocation) async => authenticatedUser);
    //     //Act
    //     final result =
    //         await authenticationRepository.authenticateWithFacebook();
    //     //Assert
    //     expect(result, Right(authenticatedUser));
    //     verify(mockAuthenticationDataSource.authenticateWithFacebook());
    //     verifyNoMoreInteractions(mockAuthenticationDataSource);
    //   });

    //   test('Should catch  AuthenticationException', () async {
    //     //Setup
    //     when(mockAuthenticationDataSource.authenticateWithFacebook()).thenThrow(
    //         AuthenticationException(
    //             messageId: MessageIds.UNEXPECTED, message: "erro"));
    //     //Act
    //     final result =
    //         await authenticationRepository.authenticateWithFacebook();
    //     // //Assert
    //     verify(mockAuthenticationDataSource.authenticateWithFacebook());
    //     verifyNoMoreInteractions(mockAuthenticationDataSource);
    //     expect(
    //       result,
    //       equals(
    //         Left(
    //           AuthenticationFailure(
    //               messageId: MessageIds.UNEXPECTED,
    //               message: 'Operação falhou. (Mensagem original: [erro])'),
    //         ),
    //       ),
    //     );
    //   });
    // });

    // group('Authenticate with email and password', () {
    //   test('Should call authenticateWithEmailAndPassword', () async {
    //     //Setup

    //     final email = 'user@test.com';
    //     final password = 'test';

    //     when(mockAuthenticationDataSource.authenticateWithEmailAndPassword(
    //             email, password))
    //         .thenAnswer((realInvocation) async => authenticatedUser);
    //     //Act
    //     final result = await authenticationRepository
    //         .authenticateWithEmailAndPassword(email, password);
    //     //Assert
    //     expect(result, Right(authenticatedUser));
    //     verify(mockAuthenticationDataSource.authenticateWithEmailAndPassword(
    //         email, password));
    //     verifyNoMoreInteractions(mockAuthenticationDataSource);
    //   });

    //   test('Should catch  AuthenticationException', () async {
    //     //Setup
    //     final email = 'user@test.com';
    //     final password = 'test';

    //     when(mockAuthenticationDataSource.authenticateWithEmailAndPassword(
    //             email, password))
    //         .thenThrow(AuthenticationException(
    //             messageId: MessageIds.EMAIL_NOT_VERIFIED));
    //     //Act
    //     final result = await authenticationRepository
    //         .authenticateWithEmailAndPassword(email, password);
    //     // //Assert
    //     verify(mockAuthenticationDataSource.authenticateWithEmailAndPassword(
    //         email, password));
    //     verifyNoMoreInteractions(mockAuthenticationDataSource);
    //     expect(
    //       result,
    //       equals(
    //         Left(
    //           AuthenticationFailure(
    //               messageId: MessageIds.EMAIL_NOT_VERIFIED,
    //               message: 'Por favor verifique seu email'),
    //         ),
    //       ),
    //     );
    //   });
    // });

    // group('Async authentication', () {
    //   test('Should should return user when success', () {
    //     //Setup

    //     final user =
    //         User(email: 'user@test.com', userId: '1', emailVerified: true);

    //     when(mockAuthenticationDataSource.asyncAuthentication())
    //         .thenAnswer((realInvocation) => Stream<User>.fromIterable([user]));
    //     //Act
    //     final result = authenticationRepository.asyncAuthentication();
    //     //Assert
    //     expect(result, emitsInOrder([Right(user)]));
    //   });
    //   test('Should return NOT_LOGGED_IN  when user is null', () {
    //     //Setup

    //     final user = null;
    //     final expected = AsyncLoginFailure(
    //         asyncLoginFailureId: AsyncLoginFailureId.NOT_LOGGED_IN);
    //     when(mockAuthenticationDataSource.asyncAuthentication())
    //         .thenAnswer((realInvocation) => Stream<User>.fromIterable([user]));
    //     //Act
    //     final result = authenticationRepository.asyncAuthentication();
    //     //Assert
    //     expect(result, emitsInOrder([Left(expected)]));
    //   });

    //   test('Should fail when email is not verified', () {
    //     //Setup

    //     final user =
    //         User(email: 'user@test.com', userId: '1', emailVerified: false);
    //     final expected = AsyncLoginFailure(
    //         asyncLoginFailureId: AsyncLoginFailureId.EMAIL_NOT_VERIFIED_FAILURE,
    //         message: "Por favor verifique seu email");
    //     when(mockAuthenticationDataSource.asyncAuthentication())
    //         .thenAnswer((realInvocation) => Stream<User>.fromIterable([user]));
    //     //Act
    //     final result = authenticationRepository.asyncAuthentication();
    //     //Assert
    //     expect(result, emitsInOrder([Left(expected)]));
    //   });
    // });

    // group('JWT', () {
    //   test('should return jwt when all ok', () async {
    //     //setup
    //     final jwt = 'JWT';
    //     when(mockAuthenticationDataSource.getJWT())
    //         .thenAnswer((realInvocation) async => jwt);
    //     //act
    //     final actual = await authenticationRepository.getJWT();
    //     //assert
    //     expect(actual, Right(jwt));
    //   });

    //   test('should return failure when on error', () async {
    //     //setup
    //     final failure = AuthenticationFailure(
    //         messageId: MessageIds.UNEXPECTED,
    //         message: "Operação falhou. (Mensagem original: [erro])");
    //     when(mockAuthenticationDataSource.getJWT()).thenThrow(
    //         AuthenticationException(
    //             messageId: MessageIds.UNEXPECTED, message: "erro"));
    //     //act
    //     final actual = await authenticationRepository.getJWT();
    //     print(actual.fold((l) => l.message, (r) => null));
    //     //assert
    //     expect(actual, Left(failure));
    //   });
    // });

    // group('Logout', () {
    //   test('should Logout when all ok', () async {
    //     //setup
    //     when(mockAuthenticationDataSource.logout())
    //         .thenAnswer((realInvocation) async => null);
    //     //act
    //     final actual = await authenticationRepository.logout();
    //     //assert
    //     expect(actual, Right(true));
    //   });

    //   test('should return failure when on error', () async {
    //     //setup
    //     final failure = AuthenticationFailure(
    //         messageId: MessageIds.UNEXPECTED,
    //         message: "Operação falhou. (Mensagem original: [erro])");
    //     when(mockAuthenticationDataSource.logout()).thenThrow(
    //         AuthenticationException(
    //             messageId: MessageIds.UNEXPECTED, message: "erro"));
    //     //act
    //     final actual = await authenticationRepository.logout();
    //     print(actual.fold((l) => l.message, (r) => null));
    //     //assert
    //     expect(actual, Left(failure));
    //   });
    // });
  });
}
