import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/User.dart';

import 'package:grocery_brasil_app/features/register/domain/usecases/register.dart';
import 'package:grocery_brasil_app/features/register/presentation/bloc/registration_bloc_bloc.dart';
import 'package:mockito/mockito.dart';

class MockRegister extends Mock implements RegistrationUseCase {}

void main() {
  MockRegister mockRegister;

  group("should register when passed email and password", () {
    final email = 'email@tes.com';
    final password = 'test';
    final expected = User(email: email, userId: '1', emailVerified: false);
    mockRegister = MockRegister();
    setUp(() {
      when(mockRegister.call(Params(email: email, password: password)))
          .thenAnswer((realInvocation) async => Right(expected));
    });
    blocTest('should register when passed login and password',
        build: () => RegistrationBloc(registrationUseCase: mockRegister),
        act: (bloc) => bloc.add(RegisterWithEmailAndPasswordEvent(
            email: email, password: password)),
        expect: [
          RegistrationBlocRunning(),
          RegistrationBlocSucceeded(user: expected)
        ]);
  });

  group("should fail when a feilure occurs", () {
    final email = 'email@tes.com';
    final password = 'test';
    final expected =
        RegistrationFailure(messageId: MessageIds.UNEXPECTED, message: 'erro');
    mockRegister = MockRegister();
    setUp(() {
      when(mockRegister.call(Params(email: email, password: password)))
          .thenAnswer((realInvocation) async => Left(expected));
    });
    blocTest('should register when passed login and password',
        build: () => RegistrationBloc(registrationUseCase: mockRegister),
        act: (bloc) => bloc.add(RegisterWithEmailAndPasswordEvent(
            email: email, password: password)),
        expect: [
          RegistrationBlocRunning(),
          RegistrationBlocFailed(failure: expected)
        ]);
  });
}
