import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/register/data/datasource/RegistrationDataSource.dart';
import 'package:grocery_brasil_app/features/register/data/repository/RegistrationRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/register/domain/repository/RegistrationRepository.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRegistrationDataSource extends Mock
    implements RegistrationDataSource {}

void main() {
  RegistrationRepository registrationRepository;
  MockRegistrationDataSource mockRegistrationDataSource;

  setUp(() {
    mockRegistrationDataSource = MockRegistrationDataSource();
    registrationRepository = RegistrationRepositoryImpl(
        registrationDataSource: mockRegistrationDataSource);
  });

  group('Register with email and password', () {
    test('should register when passed email and password', () async {
      //setup
      final email = 'test@test.com';
      final password = 'test';
      final expected = User(email: email, userId: '1', emailVerified: false);
      when(mockRegistrationDataSource.registerWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) async => expected);
      //act
      final actual = await registrationRepository.registerWithEmailAndPassword(
          email: email, password: password);
      //assert
      expect(actual, Right(expected));
      verify(mockRegistrationDataSource.registerWithEmailAndPassword(
          email: email, password: password));
      verifyNoMoreInteractions(mockRegistrationDataSource);
    });

    test('should return failure when exception happens', () async {
      //setup
      final email = 'test@test.com';
      final password = 'test';
      final expected = RegistrationException(
          messageId: MessageIds.UNEXPECTED, message: 'erro');
      when(mockRegistrationDataSource.registerWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(expected);
      //act
      final actual = await registrationRepository.registerWithEmailAndPassword(
          email: email, password: password);
      //assert
      expect(
          actual,
          Left(RegistrationFailure(
              messageId: MessageIds.UNEXPECTED,
              message: 'Falha ao criar usuário (mensagem original: [erro])')));
      verify(mockRegistrationDataSource.registerWithEmailAndPassword(
          email: email, password: password));
      verifyNoMoreInteractions(mockRegistrationDataSource);
    });
  });
}
