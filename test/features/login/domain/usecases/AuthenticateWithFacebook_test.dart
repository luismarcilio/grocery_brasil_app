import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/login/domain/repositories/AuthenticationRepository.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithFacebook.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  AuthenticateWithFacebook usecase;
  MockAuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = AuthenticateWithFacebook(repository);
  });

  final User authenticatedUser = User(email: 'test@email.com', userId: '1');

  test('should authenticate on facebook', () async {
    when(repository.authenticateWithFacebook())
        .thenAnswer((realInvocation) async => Right(authenticatedUser));
    final result = await usecase(NoParams());
    expect(result, Right(authenticatedUser));
    verify(repository.authenticateWithFacebook());
    verifyNoMoreInteractions(repository);
  });
}
