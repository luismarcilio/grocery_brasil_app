import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/login/domain/service/AuthenticationService.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/Logout.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

void main() {
  Logout usecase;
  MockAuthenticationService mockAuthenticationService;

  setUp(() {
    mockAuthenticationService = MockAuthenticationService();
    usecase = Logout(authenticationService: mockAuthenticationService);
  });

  test('should logout', () async {
    //Setup
    when(mockAuthenticationService.logout())
        .thenAnswer((realInvocation) async => Right(true));
    //Act
    final result = await usecase(NoParams());
    //Assert
    expect(result, Right(true));
    verify(mockAuthenticationService.logout());
    verifyNoMoreInteractions(mockAuthenticationService);
  });
}
