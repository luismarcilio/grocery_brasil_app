import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/register/domain/repository/RegistrationRepository.dart';
import 'package:grocery_brasil_app/features/register/domain/usecases/register.dart';
import 'package:mockito/mockito.dart';

class MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

void main() {
  RegistrationUseCase usecase;
  MockRegistrationRepository repository;

  setUp(() {
    repository = MockRegistrationRepository();
    usecase = RegistrationUseCase(repository);
  });

  group('Registration use case', () {
    test('should register when passed email and password', () async {
      //setup
      final email = 'test@test.com';
      final password = 'test';
      final expected = User(email: email, userId: '1', emailVerified: false);
      when(repository.registerWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) async => Right(expected));
      //act
      final actual =
          await usecase.call(Params(email: email, password: password));
      //assert
      expect(actual, Right(expected));
      verify(repository.registerWithEmailAndPassword(
          email: email, password: password));
      verifyNoMoreInteractions(repository);
    });

    test('should fail when an exception occurs', () async {
      //setup
      final email = 'test@test.com';
      final password = 'test';
      final expected = RegistrationFailure(
          messageId: MessageIds.UNEXPECTED,
          message: 'Falha ao criar usuário (mensagem original: [erro])');
      when(repository.registerWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) async => Left(expected));
      //act
      final actual =
          await usecase.call(Params(email: email, password: password));
      //assert
      expect(actual, Left(expected));
      verify(repository.registerWithEmailAndPassword(
          email: email, password: password));
      verifyNoMoreInteractions(repository);
    });
  });
}
