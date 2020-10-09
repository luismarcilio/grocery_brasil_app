import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/login/domain/repositories/AuthenticationRepository.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithEmailAndPassword.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  AuthenticateWithEmailAndPassword usecase;
  MockAuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = AuthenticateWithEmailAndPassword(repository);
  });

  final User authenticatedUser = User(email: 'test@email.com', userId: '1');

  test('should authenticate with username and password', () async {
    final String email = 'test@email.com';
    final String password = 'test';

    when(repository.authenticateWithEmailAndPassword(email, password))
        .thenAnswer((realInvocation) async => Right(authenticatedUser));
    final result = await usecase(Params(email, password));
    expect(result, Right(authenticatedUser));
    verify(repository.authenticateWithEmailAndPassword(email, password));
    verifyNoMoreInteractions(repository);
  });
}
