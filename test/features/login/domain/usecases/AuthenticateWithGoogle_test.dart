import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/login/domain/repositories/AuthenticationRepository.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithGoogle.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  AuthenticateWithGoogle usecase;
  MockAuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = AuthenticateWithGoogle(repository);
  });

  final User authenticatedUser = User(email: 'test@email.com', userId: '1');

  test('should authenticate on google', () async {
    //Setup
    when(repository.authenticateWithGoogle())
        .thenAnswer((realInvocation) async => Right(authenticatedUser));
    //Act
    final result = await usecase(NoParams());
    //Assert
    expect(result, Right(authenticatedUser));
    verify(repository.authenticateWithGoogle());
    verifyNoMoreInteractions(repository);
  });
}
