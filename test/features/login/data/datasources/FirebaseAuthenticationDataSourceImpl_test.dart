import 'package:firebase_auth/firebase_auth.dart'
    show AuthCredential, FirebaseAuth, User, UserCredential, UserInfo;
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/User.dart' as Domain;
import 'package:grocery_brasil_app/features/login/data/datasources/AuthenticationDataSource.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/FirebaseAuthenticationDataSourceImpl.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/FirebaseOAuthProvider.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseOAuthProvider extends Mock implements FirebaseOAuthProvider {}

class MockUser extends Mock implements User {}

void main() {
  AuthenticationDataSource authenticationDataSource;
  MockFirebaseAuth mockFirebaseAuth;
  MockAuthCredential mockAuthCredential;
  MockUserCredential mockUserCredential;
  MockFirebaseOAuthProvider mockFirebaseOAuthProvider;
  MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockAuthCredential = MockAuthCredential();
    mockUserCredential = MockUserCredential();
    mockFirebaseOAuthProvider = MockFirebaseOAuthProvider();
    mockUser = MockUser();
    authenticationDataSource = FirebaseAuthenticationDataSourceImpl(
        firebaseAuth: mockFirebaseAuth,
        oAuthProvider: mockFirebaseOAuthProvider);
  });

  group('Authenticate with google user credential', () {
    test('should authenticate when passed google user credential', () async {
      //setup
      when(mockUserCredential.user).thenAnswer((realInvocation) => mockUser);
      when(mockUser.email).thenAnswer((realInvocation) => 'user@test.com');
      when(mockUser.uid).thenAnswer((realInvocation) => '1');
      when(mockFirebaseOAuthProvider.call(OAuthProviderEntities.GOOGLE))
          .thenAnswer((realInvocation) async => mockAuthCredential);
      when(mockUser.providerData).thenAnswer(
        (realInvocation) => List<UserInfo>.of([
          UserInfo({'providerId': 'google'})
        ]),
      );

      final expected = Domain.User(userId: '1', email: 'user@test.com');

      when(mockFirebaseAuth.signInWithCredential(mockAuthCredential))
          .thenAnswer((_) => Future<UserCredential>.value(mockUserCredential));

      //act
      final result = await authenticationDataSource.authenticateWithGoogle();
      //assert
      expect(result, equals(expected));
      verify(mockFirebaseAuth.signInWithCredential(mockAuthCredential));
      verifyNoMoreInteractions(mockFirebaseAuth);
    });

    test('should fail exception is thrown', () async {
      //setup
      when(mockUserCredential.user).thenAnswer((realInvocation) => mockUser);
      when(mockUser.email).thenAnswer((realInvocation) => 'user@test.com');
      when(mockUser.uid).thenAnswer((realInvocation) => '1');
      when(mockFirebaseOAuthProvider.call(OAuthProviderEntities.GOOGLE))
          .thenAnswer((realInvocation) async => mockAuthCredential);
      when(mockFirebaseAuth.signInWithCredential(mockAuthCredential))
          .thenThrow(Exception("erro"));
      when(mockUser.providerData).thenAnswer(
        (realInvocation) => List<UserInfo>.of([
          UserInfo({'providerId': 'google'})
        ]),
      );

      expect(
          () async => await authenticationDataSource.authenticateWithGoogle(),
          throwsA(AuthenticationException(
              messageId: MessageIds.UNEXPECTED,
              message:
                  "Autenticação falhou. (Mensagem original: [Exception: erro])")));
      // verify(mockFirebaseAuth.signInWithCredential(mockAuthCredential));
      verifyNoMoreInteractions(mockFirebaseAuth);
    });
  });

  group('Authenticate with facebook user credential', () {
    test('should authenticate when passed facebook user credential', () async {
      //setup
      when(mockUserCredential.user).thenAnswer((realInvocation) => mockUser);
      when(mockUser.email).thenAnswer((realInvocation) => 'user@test.com');
      when(mockUser.uid).thenAnswer((realInvocation) => '1');
      when(mockFirebaseOAuthProvider.call(OAuthProviderEntities.FACEBOOK))
          .thenAnswer((realInvocation) async => mockAuthCredential);
      when(mockUser.providerData).thenAnswer(
        (realInvocation) => List<UserInfo>.of([
          UserInfo({'providerId': 'facebook'})
        ]),
      );

      final expected = Domain.User(userId: '1', email: 'user@test.com');

      when(mockFirebaseAuth.signInWithCredential(mockAuthCredential))
          .thenAnswer((_) => Future<UserCredential>.value(mockUserCredential));

      //act
      final result = await authenticationDataSource.authenticateWithFacebook();
      //assert
      expect(result, equals(expected));
      verify(mockFirebaseAuth.signInWithCredential(mockAuthCredential));
      verifyNoMoreInteractions(mockFirebaseAuth);
    });

    test('should fail exception is thrown', () async {
      //setup
      when(mockUserCredential.user).thenAnswer((realInvocation) => mockUser);
      when(mockUser.email).thenAnswer((realInvocation) => 'user@test.com');
      when(mockUser.uid).thenAnswer((realInvocation) => '1');
      when(mockFirebaseOAuthProvider.call(OAuthProviderEntities.FACEBOOK))
          .thenAnswer((realInvocation) async => mockAuthCredential);
      when(mockFirebaseAuth.signInWithCredential(mockAuthCredential))
          .thenThrow(Exception("erro"));
      when(mockUser.providerData).thenAnswer(
        (realInvocation) => List<UserInfo>.of([
          UserInfo({'providerId': 'facebook'})
        ]),
      );

      //assert
      expect(
          () async => await authenticationDataSource.authenticateWithFacebook(),
          throwsA(AuthenticationException(
              messageId: MessageIds.UNEXPECTED,
              message:
                  "Autenticação falhou. (Mensagem original: [Exception: erro])")));
      // verify(mockFirebaseAuth.signInWithCredential(mockAuthCredential));
      verifyNoMoreInteractions(mockFirebaseAuth);
    });
  });

  group('Authenticate with username and password', () {
    test('should authenticate when passed fusername and password', () async {
      //setup
      final email = 'user@test.com';
      final password = 'test';
      final expected =
          Domain.User(userId: '1', email: email, emailVerified: true);
      when(mockUserCredential.user).thenAnswer((realInvocation) => mockUser);
      when(mockUser.email).thenAnswer((realInvocation) => expected.email);
      when(mockUser.uid).thenAnswer((realInvocation) => expected.userId);
      when(mockUser.uid).thenAnswer((realInvocation) => expected.userId);
      when(mockUser.providerData).thenAnswer(
        (realInvocation) => List<UserInfo>.of([
          UserInfo({'providerId': 'password'})
        ]),
      );

      when(mockUser.emailVerified)
          .thenAnswer((realInvocation) => expected.emailVerified);

      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) => Future<UserCredential>.value(mockUserCredential));

      //act
      final result = await authenticationDataSource
          .authenticateWithEmailAndPassword(email, password);
      //assert
      expect(result, equals(expected));
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password));
      verifyNoMoreInteractions(mockFirebaseAuth);
    });
    test('should throw error if email is not verified', () async {
      //setup
      final email = 'user@test.com';
      final password = 'test';
      final expected =
          Domain.User(userId: '1', email: email, emailVerified: false);
      when(mockUserCredential.user).thenAnswer((realInvocation) => mockUser);
      when(mockUser.email).thenAnswer((realInvocation) => expected.email);
      when(mockUser.uid).thenAnswer((realInvocation) => expected.userId);
      when(mockUser.providerData).thenAnswer(
        (realInvocation) => List<UserInfo>.of([
          UserInfo({'providerId': 'password'})
        ]),
      );
      when(mockUser.emailVerified)
          .thenAnswer((realInvocation) => expected.emailVerified);

      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) => Future<UserCredential>.value(mockUserCredential));

      expect(
          () async => await authenticationDataSource
              .authenticateWithEmailAndPassword(email, password),
          throwsA(AuthenticationException(
              messageId: MessageIds.EMAIL_NOT_VERIFIED)));
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password));
      verifyNoMoreInteractions(mockFirebaseAuth);
    });

    test('should fail exception is thrown', () async {
      //setup
      final email = 'user@test.com';
      final password = 'test';
      final expected =
          Domain.User(userId: '1', email: email, emailVerified: false);
      when(mockUserCredential.user).thenAnswer((realInvocation) => mockUser);
      when(mockUser.email).thenAnswer((realInvocation) => expected.email);
      when(mockUser.uid).thenAnswer((realInvocation) => expected.userId);
      when(mockUser.emailVerified)
          .thenAnswer((realInvocation) => expected.emailVerified);
      when(mockUser.providerData).thenAnswer(
        (realInvocation) => List<UserInfo>.of([
          UserInfo({'providerId': 'password'})
        ]),
      );

      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(Exception("erro"));

      //act
      // await authenticationDataSource.authenticateWithGoogle();
      //assert
      expect(
          () async => await authenticationDataSource
              .authenticateWithEmailAndPassword(email, password),
          throwsA(AuthenticationException(
              messageId: MessageIds.UNEXPECTED,
              message:
                  "Autenticação falhou. (Mensagem original: [Exception: erro])")));
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password));
      verifyNoMoreInteractions(mockFirebaseAuth);
    });
  });
}
