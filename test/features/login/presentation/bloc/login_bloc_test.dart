import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AsyncLogin.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithEmailAndPassword.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithFacebook.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithGoogle.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/Logout.dart';
import 'package:grocery_brasil_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:grocery_brasil_app/features/user/domain/CreateUserUseCase.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticateWithEmailAndPassword extends Mock
    implements AuthenticateWithEmailAndPassword {}

class MockAuthenticateWithFacebook extends Mock
    implements AuthenticateWithFacebook {}

class MockAuthenticateWithGoogle extends Mock
    implements AuthenticateWithGoogle {}

class MockLogout extends Mock implements Logout {}

class MockAsyncLogin extends Mock implements AsyncLogin {}

class MockCreateUserUseCase extends Mock implements CreateUserUseCase {}

void main() {
  LoginBloc loginBloc;

  MockAuthenticateWithEmailAndPassword mockAuthenticateWithEmailAndPassword;
  MockAuthenticateWithFacebook mockAuthenticateWithFacebook;
  MockAuthenticateWithGoogle mockAuthenticateWithGoogle;
  MockLogout mockLogout;
  MockAsyncLogin mockAsyncLogin;
  MockCreateUserUseCase mockCreateUserUseCase;
  setUp(() {
    mockAuthenticateWithEmailAndPassword =
        MockAuthenticateWithEmailAndPassword();
    mockAuthenticateWithFacebook = MockAuthenticateWithFacebook();
    mockAuthenticateWithGoogle = MockAuthenticateWithGoogle();
    mockLogout = MockLogout();
    mockAsyncLogin = MockAsyncLogin();
    mockCreateUserUseCase = MockCreateUserUseCase();
    when(mockAsyncLogin(any)).thenAnswer(
        (realInvocation) => Stream<Either<AsyncLoginFailure, User>>.empty());
    loginBloc = LoginBloc(
        authenticateWithEmailAndPassword: mockAuthenticateWithEmailAndPassword,
        authenticateWithFacebook: mockAuthenticateWithFacebook,
        authenticateWithGoogle: mockAuthenticateWithGoogle,
        logout: mockLogout,
        createUser: mockCreateUserUseCase,
        asyncLogin: mockAsyncLogin);
  });

  test('initial state should be LoginInitial', () {
    expect(loginBloc.initialState, equals(LoginInitial()));
  });

  group('asynchronous login', () {
    group('should login', () {
      final expectedUser = User(email: 'test@email.com', userId: '1');

      setUp(() {
        when(mockAsyncLogin(any)).thenAnswer(
          (realInvocation) =>
              Stream<Either<AsyncLoginFailure, User>>.fromIterable(
                  [Right(expectedUser)]),
        );
        when(mockCreateUserUseCase.call(expectedUser))
            .thenAnswer((realInvocation) async => Right(expectedUser));
      });
      blocTest('should login',
          build: () => LoginBloc(
              authenticateWithEmailAndPassword:
                  mockAuthenticateWithEmailAndPassword,
              authenticateWithFacebook: mockAuthenticateWithFacebook,
              authenticateWithGoogle: mockAuthenticateWithGoogle,
              logout: mockLogout,
              createUser: mockCreateUserUseCase,
              asyncLogin: mockAsyncLogin),
          act: (bloc) {},
          expect: [LoginRunning(), UserCreating(), LoginDone(expectedUser)]);
    });

    group('should error', () {
      final asyncLoginFailure = AsyncLoginFailure(
          asyncLoginFailureId: AsyncLoginFailureId.GENERAL_FAILURE,
          message: "Falha");

      setUp(() {
        when(mockAsyncLogin(any)).thenAnswer(
          (realInvocation) =>
              Stream<Either<AsyncLoginFailure, User>>.fromIterable(
                  [Left(asyncLoginFailure)]),
        );
      });
      blocTest('asynchronous login should error',
          build: () => LoginBloc(
              authenticateWithEmailAndPassword:
                  mockAuthenticateWithEmailAndPassword,
              authenticateWithFacebook: mockAuthenticateWithFacebook,
              authenticateWithGoogle: mockAuthenticateWithGoogle,
              logout: mockLogout,
              createUser: mockCreateUserUseCase,
              asyncLogin: mockAsyncLogin),
          act: (bloc) {},
          expect: [
            LoginRunning(),
            LoginError(AuthenticationFailure(
                messageId: MessageIds.UNEXPECTED,
                message: asyncLoginFailure.message)),
            LogoutDone()
          ]);
    });
  });

  group('Login with email and password', () {
    final email = 'test@email.com';
    final password = 'test';
    group('should authenticate when passed login and password', () {
      final expectedUser = User(email: 'test@email.com', userId: '1');
      setUp(() {
        when(mockAuthenticateWithEmailAndPassword(Params(email, password)))
            .thenAnswer((realInvocation) async => Right(expectedUser));
        when(mockCreateUserUseCase.call(expectedUser))
            .thenAnswer((realInvocation) async => Right(expectedUser));
      });
      blocTest('should authenticate when passed login and password',
          build: () => loginBloc,
          act: (bloc) => bloc.add(LoginWithUsernameAndPasswordEvent(
              email: email, password: password)),
          expect: [LoginRunning(), UserCreating(), LoginDone(expectedUser)]);
    });
    group('should fail when login fails', () {
      final expectedFail = AuthenticationFailure(
          messageId: MessageIds.UNEXPECTED, message: "unexpected");
      setUp(() {
        when(mockAuthenticateWithEmailAndPassword.call(Params(email, password)))
            .thenAnswer(
          (realInvocation) async => Left(expectedFail),
        );
      });
      blocTest('should fail when login fails',
          build: () => loginBloc,
          act: (bloc) => bloc.add(LoginWithUsernameAndPasswordEvent(
              email: email, password: password)),
          expect: [LoginRunning(), LoginError(expectedFail)]);
    });
  });

  group('Login with Google', () {
    group('should authenticate with google', () {
      final expectedUser = User(email: 'test@email.com', userId: '1');
      setUp(() {
        when(mockAuthenticateWithGoogle.call(NoParams()))
            .thenAnswer((realInvocation) async => Right(expectedUser));
        when(mockCreateUserUseCase.call(expectedUser))
            .thenAnswer((realInvocation) async => Right(expectedUser));
      });
      blocTest('should authenticate with google',
          build: () => loginBloc,
          act: (bloc) => bloc.add(LoginWithGoogleEvent()),
          expect: [LoginRunning(), UserCreating(), LoginDone(expectedUser)]);
    });
    group('should fail when login fails', () {
      final expectedFail = AuthenticationFailure(
          messageId: MessageIds.UNEXPECTED, message: "unexpected");
      setUp(() {
        when(mockAuthenticateWithGoogle.call(NoParams())).thenAnswer(
          (realInvocation) async => Left(expectedFail),
        );
      });
      blocTest('should fail when login fails',
          build: () => loginBloc,
          act: (bloc) => bloc.add(LoginWithGoogleEvent()),
          expect: [LoginRunning(), LoginError(expectedFail)]);
    });
  });

  group('Login with Facebook', () {
    group('should authenticate with Facebook', () {
      final expectedUser = User(email: 'test@email.com', userId: '1');
      setUp(() {
        when(mockAuthenticateWithFacebook.call(NoParams()))
            .thenAnswer((realInvocation) async => Right(expectedUser));
        when(mockCreateUserUseCase.call(expectedUser))
            .thenAnswer((realInvocation) async => Right(expectedUser));
      });
      blocTest('should authenticate with facebook',
          build: () => loginBloc,
          act: (bloc) => bloc.add(LoginWithFacebookEvent()),
          expect: [LoginRunning(), UserCreating(), LoginDone(expectedUser)]);
    });
    group('should fail when login fails', () {
      final expectedFail = AuthenticationFailure(
          messageId: MessageIds.UNEXPECTED, message: "unexpected");
      setUp(() {
        when(mockAuthenticateWithFacebook.call(NoParams())).thenAnswer(
          (realInvocation) async => Left(expectedFail),
        );
      });
      blocTest('should fail when login fails',
          build: () => loginBloc,
          act: (bloc) => bloc.add(LoginWithFacebookEvent()),
          expect: [LoginRunning(), LoginError(expectedFail)]);
    });
  });

  group('Logout', () {
    group('should logout', () {
      setUp(() {
        when(mockLogout.call(NoParams()))
            .thenAnswer((realInvocation) async => Right(true));
      });
      blocTest('should logout',
          build: () => loginBloc,
          act: (bloc) => bloc.add(LogoutEvent()),
          expect: [LoginRunning(), LogoutDone()]);
    });
  });

  group('create user', () {
    group('should create user', () {
      final user = User(email: 'test@email.com', userId: '1');
      setUp(() {
        when(mockCreateUserUseCase.call(user))
            .thenAnswer((realInvocation) async => Right(user));
      });

      blocTest('should create user',
          build: () => loginBloc,
          act: (bloc) => bloc.add(CreateUserEvent(user: user)),
          expect: [UserCreating(), LoginDone(user)]);
    });

    group('should return error if fails', () {
      final user = User(email: 'test@email.com', userId: '1');
      final expected =
          UserFailure(messageId: MessageIds.UNEXPECTED, message: 'some error');
      setUp(() {
        when(mockCreateUserUseCase.call(user))
            .thenAnswer((realInvocation) async => Left(expected));
      });
      blocTest('should fail creating user',
          build: () => loginBloc,
          act: (bloc) => bloc.add(CreateUserEvent(user: user)),
          expect: [UserCreating(), CreateUserFailure(expected)]);
    });
  });
}
