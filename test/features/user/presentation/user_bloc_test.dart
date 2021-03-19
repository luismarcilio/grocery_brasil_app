import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/user/domain/GetUserUseCase.dart';
import 'package:grocery_brasil_app/features/user/domain/UpdateUserUseCase.dart';
import 'package:grocery_brasil_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:mockito/mockito.dart';

class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

main() {
  MockUpdateUserUseCase mockUpdateUserUseCase;
  MockGetUserUseCase mockGetUserUseCase;
  group('UserBloc', () {
    setUp(() {
      mockUpdateUserUseCase = MockUpdateUserUseCase();
      mockGetUserUseCase = MockGetUserUseCase();
    });

    group('should update the user', () {
      final someUser = User(email: 'someEmail', userId: 'someUserId');
      setUp(() {
        when(mockUpdateUserUseCase(someUser))
            .thenAnswer((realInvocation) async => Right(someUser));
      });
      blocTest('should update the user',
          build: () => UserBloc(
              updateUserUseCase: mockUpdateUserUseCase,
              getUserUseCase: mockGetUserUseCase),
          act: (bloc) => bloc.add(UpdateUser(user: someUser)),
          expect: () => [UserUpdating(), UserReady(user: someUser)]);
    });

    group('should return userError when it receives some failure', () {
      final someUser = User(email: 'someEmail', userId: 'someUserId');
      final failure =
          UserFailure(messageId: MessageIds.UNEXPECTED, message: 'some error');
      setUp(() {
        when(mockUpdateUserUseCase(someUser))
            .thenAnswer((realInvocation) async => Left(failure));
      });
      blocTest('should return userError when it receives some failure',
          build: () => UserBloc(
              updateUserUseCase: mockUpdateUserUseCase,
              getUserUseCase: mockGetUserUseCase),
          act: (bloc) => bloc.add(UpdateUser(user: someUser)),
          expect: () => [UserUpdating(), UserError(failure: failure)]);
    });

    group('should get the user', () {
      final someUser = User(email: 'someEmail', userId: 'someUserId');
      setUp(() {
        when(mockGetUserUseCase(NoParams()))
            .thenAnswer((realInvocation) async => Right(someUser));
      });
      blocTest('should get the user',
          build: () => UserBloc(
              updateUserUseCase: mockUpdateUserUseCase,
              getUserUseCase: mockGetUserUseCase),
          act: (bloc) => bloc.add(GetUser()),
          expect: () => [UserUpdating(), UserReady(user: someUser)]);
    });
  });
}
