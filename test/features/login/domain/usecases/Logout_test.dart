import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/login/domain/repositories/AuthenticationRepository.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/Logout.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  Logout usecase;
  MockAuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = Logout(repository);
  });

  test('should logout', () async {
    //Setup
    when(repository.logout()).thenAnswer((realInvocation) async => Right(true));
    //Act
    final result = await usecase(NoParams());
    //Assert
    expect(result, Right(true));
    verify(repository.logout());
    verifyNoMoreInteractions(repository);
  });
}
