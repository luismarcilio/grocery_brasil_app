import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/login/domain/service/AuthenticationService.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithGoogle.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

void main() {
  AuthenticateWithGoogle usecase;
  MockAuthenticationService mockAuthenticationService;

  setUp(() {
    mockAuthenticationService = MockAuthenticationService();
    usecase = AuthenticateWithGoogle(
        authenticationService: mockAuthenticationService);
  });

  final User authenticatedUser = User(email: 'test@email.com', userId: '1');

  test('should authenticate on google', () async {
    //Setup
    when(mockAuthenticationService.authenticateWithGoogle())
        .thenAnswer((realInvocation) async => Right(authenticatedUser));
    //Act
    final result = await usecase(NoParams());
    //Assert
    expect(result, Right(authenticatedUser));
    verify(mockAuthenticationService.authenticateWithGoogle());
    verifyNoMoreInteractions(mockAuthenticationService);
  });
}
