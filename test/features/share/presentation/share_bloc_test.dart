import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareUseCase.dart';
import 'package:grocery_brasil_app/features/share/presentation/bloc/share_bloc.dart';
import 'package:mockito/mockito.dart';

class MockShareUseCase extends Mock implements ShareUseCase {}

main() {
  group('share bloc test', () {
    group('should send Sharing and Shared', () {
      MockShareUseCase mockShareUseCase = MockShareUseCase();
      when(mockShareUseCase
              .call(Params(content: 'some text', format: ShareFormat.TEXT)))
          .thenAnswer((realInvocation) async => Right(true));
      blocTest('Should send sharing and shared',
          build: () => ShareBloc(shareUseCase: mockShareUseCase),
          act: (bloc) => bloc.add(ShareText(textToShare: 'some text')),
          expect: () => [Sharing(), Shared()]);
    });
    group('should send Sharing and Shared error', () {
      MockShareUseCase mockShareUseCase = MockShareUseCase();
      when(mockShareUseCase
              .call(Params(content: 'some text', format: ShareFormat.TEXT)))
          .thenAnswer((realInvocation) async => Left(ShareFailure(
              messageId: MessageIds.UNEXPECTED, message: 'ERROR')));
      blocTest('Should send sharing and shared',
          build: () => ShareBloc(shareUseCase: mockShareUseCase),
          act: (bloc) => bloc.add(ShareText(textToShare: 'some text')),
          expect: () => [
                Sharing(),
                ShareError(
                    shareFailure: ShareFailure(
                        messageId: MessageIds.UNEXPECTED, message: 'ERROR'))
              ]);
    });
  });
}
