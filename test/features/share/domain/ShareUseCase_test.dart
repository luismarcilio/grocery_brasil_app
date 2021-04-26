import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';

import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareService.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareUseCase.dart';
import 'package:mockito/mockito.dart';

class MockShareService extends Mock implements ShareService {}

main() {
  MockShareService mockShareService;
  ShareUseCase sut;

  setUp(() {
    mockShareService = MockShareService();
    sut = ShareUseCase(shareService: mockShareService);
  });

  group('ShareUseCase', () {
    test('Should call service', () async {
      //setup
      final input = 'Data text to be shared';
      final format = ShareFormat.TEXT;
      final expected = true;

      when(mockShareService.shareContent(input, format))
          .thenAnswer((realInvocation) async => true);

      //act
      final actual =
          await sut(Params(content: input, format: ShareFormat.TEXT));
      //assert
      expect(actual, Right(expected));
    });

    test('Should sould return failure if some exception occurs', () async {
      //setup
      final input = 'Data text to be shared';
      final format = ShareFormat.TEXT;
      final expected = ShareFailure(
          messageId: MessageIds.UNEXPECTED, message: 'Exception: Error');

      when(mockShareService.shareContent(input, format))
          .thenThrow(Exception('Error'));
      //act
      final actual =
          await sut(Params(content: input, format: ShareFormat.TEXT));
      //assert
      expect(actual, Left(expected));
    });
  });
}
