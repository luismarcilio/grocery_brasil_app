import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/asyncUseCase.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/login/domain/repositories/AuthenticationRepository.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AsyncLogin.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  AsyncLogin usecase;
  MockAuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = AsyncLogin(repository);
  });
  final User authenticatedUser = User(email: 'test@email.com', userId: '1');

  test('Successfull async login', () async {
    //Setup
    when(repository.asyncAuthentication()).thenAnswer(
      (realInvocation) => Stream<Either<AsyncLoginFailure, User>>.fromIterable(
          [Right(authenticatedUser)]),
    );
    //Act
    final result = usecase(NoParams());
    //Assert
    expect(result, emitsInOrder([Right(authenticatedUser)]));
  });
}
