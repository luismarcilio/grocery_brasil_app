import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareUseCase.dart';
import 'package:grocery_brasil_app/features/share/domain/Shareable.dart';
import 'package:grocery_brasil_app/features/share/presentation/bloc/share_bloc.dart';
import 'package:mockito/mockito.dart';

class MockShareUseCase extends Mock implements ShareUseCase {}

main() {
  group('share bloc test', () {
    group('should send Sharing and Shared', () {
      MockShareUseCase mockShareUseCase = MockShareUseCase();
      final input = Shareable(
          content: ShareableContent(text: 'someText'),
          format: ShareFormat.TEXT);
      when(mockShareUseCase.call(Params(shareable: input)))
          .thenAnswer((realInvocation) async => Right(true));
      blocTest('Should send sharing and shared',
          build: () => ShareBloc(shareUseCase: mockShareUseCase),
          act: (bloc) => bloc.add(ShareContent(shareable: input)),
          expect: () => [Sharing(), Shared()]);
    });
    group('should send Sharing and Shared error', () {
      MockShareUseCase mockShareUseCase = MockShareUseCase();
      final input = Shareable(
          content: ShareableContent(text: 'someText'),
          format: ShareFormat.TEXT);
      when(mockShareUseCase.call(Params(shareable: input))).thenAnswer(
        (realInvocation) async => Left(
          ShareFailure(messageId: MessageIds.UNEXPECTED, message: 'ERROR'),
        ),
      );
      blocTest('Should send sharing and shared',
          build: () => ShareBloc(shareUseCase: mockShareUseCase),
          act: (bloc) => bloc.add(ShareContent(shareable: input)),
          expect: () => [
                Sharing(),
                ShareError(
                  shareFailure: ShareFailure(
                      messageId: MessageIds.UNEXPECTED, message: 'ERROR'),
                )
              ]);
    });
  });
}
