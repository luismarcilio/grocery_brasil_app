import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/login/domain/service/AuthenticationService.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithEmailAndPassword.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

void main() {
  AuthenticateWithEmailAndPassword usecase;
  MockAuthenticationService mockAuthenticationService;

  setUp(() {
    mockAuthenticationService = MockAuthenticationService();
    usecase = AuthenticateWithEmailAndPassword(
        authenticationService: mockAuthenticationService);
  });

  final User authenticatedUser = User(email: 'test@email.com', userId: '1');

  test('should authenticate with username and password', () async {
    final String email = 'test@email.com';
    final String password = 'test';

    when(mockAuthenticationService.authenticateWithEmailAndPassword(
            email, password))
        .thenAnswer((realInvocation) async => Right(authenticatedUser));
    final result = await usecase(Params(email, password));
    expect(result, Right(authenticatedUser));
    verify(mockAuthenticationService.authenticateWithEmailAndPassword(
        email, password));
    verifyNoMoreInteractions(mockAuthenticationService);
  });
}
