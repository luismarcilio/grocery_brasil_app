import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, User, UserCredential;
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/User.dart' as Domain;

import 'package:grocery_brasil_app/features/register/data/datasource/FirebaseRegistrationDataSourceImpl.dart';
import 'package:grocery_brasil_app/features/register/data/datasource/RegistrationDataSource.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  RegistrationDataSource registrationDataSource;
  MockFirebaseAuth mockFirebaseAuth;
  MockUserCredential mockUserCredential;
  MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    registrationDataSource =
        FirebaseRegistrationDataSourceImpl(firebaseAuth: mockFirebaseAuth);
  });

  group('Registration tests Firebase', () {
    test('should register when passed username and password', () async {
//setup
      final email = 'test@test.com';
      final password = 'test';
      final uid = '1';
      final expected =
          Domain.User(email: email, userId: uid, emailVerified: false);

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.email).thenReturn(email);
      when(mockUser.emailVerified).thenReturn(false);
      when(mockUser.uid).thenReturn(uid);
//act
      final actual = await registrationDataSource.registerWithEmailAndPassword(
          email: email, password: password);
//assert
      expect(expected, actual);
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password));
      verify(mockUser.sendEmailVerification());
      verifyNoMoreInteractions(mockFirebaseAuth);
    });

    test('should throw exception when fails', () async {
//setup
      final email = 'test@test.com';
      final password = 'test';
      final uid = '1';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(Exception('erro'));
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.email).thenReturn(email);
      when(mockUser.emailVerified).thenReturn(false);
      when(mockUser.uid).thenReturn(uid);

//assert
      expect(
          () async => await registrationDataSource.registerWithEmailAndPassword(
              email: email, password: password),
          throwsA(RegistrationException(
              messageId: MessageIds.UNEXPECTED,
              message:
                  "Operação falhou. (Mensagem original: [Exception: erro])")));
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password));
      verifyNoMoreInteractions(mockFirebaseAuth);
    });
  });
}
