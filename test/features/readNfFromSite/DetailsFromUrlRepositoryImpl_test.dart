import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/DetailsFromUrlDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/DetailsFromUrlRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/DetailsFromUrlRepository.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NFProcessData.dart';
import 'package:mockito/mockito.dart';

class MockDetailsFromUrlDataSource extends Mock
    implements DetailsFromUrlDataSource {}

main() {
  MockDetailsFromUrlDataSource mockDetailsFromUrlDataSource;
  DetailsFromUrlRepository detailsFromUrlRepositoryImpl;

  setUp(() {
    mockDetailsFromUrlDataSource = MockDetailsFromUrlDataSource();
    detailsFromUrlRepositoryImpl = DetailsFromUrlRepositoryImpl(
        detailsFromUrldataSource: mockDetailsFromUrlDataSource);
  });

  group('DetailsFromUrlRepositoryImpl', () {
    test('should return NFProcessDataFailure on error', () async {
      //setup
      final expected = NFProcessDataFailure(
          messageId: MessageIds.UNEXPECTED,
          message: 'Operação falhou. Mensagem original: [Exception: erro]');

      when(mockDetailsFromUrlDataSource(url: 'url'))
          .thenThrow(Exception('erro'));
      //act
      final actual = await detailsFromUrlRepositoryImpl(url: 'url');
      print(actual.fold((l) => l.message, (r) => r));
      //assert
      expect(actual, Left(expected));
      verify(mockDetailsFromUrlDataSource.call(url: 'url'));
    });

    test('should return NFProcessData when everything goes ok', () async {
      //setup
      final expected = NFProcessData(
          accessKey: 'accessKey',
          initialUrl: 'http://test',
          javascriptFunctions: 'functions',
          state: 'RJ');

      when(mockDetailsFromUrlDataSource(url: 'url'))
          .thenAnswer((realInvocation) async => expected);
      //act
      final actual = await detailsFromUrlRepositoryImpl(url: 'url');
      //assert
      expect(actual, Right(expected));
      verify(mockDetailsFromUrlDataSource.call(url: 'url'));
    });
  });
}
