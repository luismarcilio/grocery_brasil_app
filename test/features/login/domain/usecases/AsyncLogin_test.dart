import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/asyncUseCase.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/login/domain/service/AuthenticationService.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AsyncLogin.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

void main() {
  AsyncLogin usecase;
  MockAuthenticationService mockAuthenticationService;

  setUp(() {
    mockAuthenticationService = MockAuthenticationService();
    usecase = AsyncLogin(authenticationService: mockAuthenticationService);
  });
  final User authenticatedUser = User(email: 'test@email.com', userId: '1');

  test('Successfull async login', () async {
    //Setup
    when(mockAuthenticationService.asyncAuthentication()).thenAnswer(
      (realInvocation) => Stream<Either<AsyncLoginFailure, User>>.fromIterable(
          [Right(authenticatedUser)]),
    );
    //Act
    final result = usecase(NoParams());
    //Assert
    expect(result, emitsInOrder([Right(authenticatedUser)]));
  });
}
