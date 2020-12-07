import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/login/domain/service/AuthenticationService.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AuthenticateWithFacebook.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

void main() {
  AuthenticateWithFacebook usecase;
  MockAuthenticationService mockAuthenticationService;

  setUp(() {
    mockAuthenticationService = MockAuthenticationService();
    usecase = AuthenticateWithFacebook(
        authenticationService: mockAuthenticationService);
  });

  final User authenticatedUser = User(email: 'test@email.com', userId: '1');

  test('should authenticate on facebook', () async {
    when(mockAuthenticationService.authenticateWithFacebook())
        .thenAnswer((realInvocation) async => Right(authenticatedUser));
    final result = await usecase(NoParams());
    expect(result, Right(authenticatedUser));
    verify(mockAuthenticationService.authenticateWithFacebook());
    verifyNoMoreInteractions(mockAuthenticationService);
  });
}
