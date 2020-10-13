import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/NFDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/NfRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/NfRepository.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NfHtmlFromSite.dart';
import 'package:mockito/mockito.dart';

class MockNFDataSource extends Mock implements NFDataSource {}

main() {
  MockNFDataSource mockNFDataSource;
  NfRepository nfRepository;

  setUp(() {
    mockNFDataSource = MockNFDataSource();
    nfRepository = NfRepositoryImpl(nfDataSource: mockNFDataSource);
  });

  group('NfRepositoryImpl.save', () {
    test('should return NFProcessDataFailure on error', () async {
      //setup
      final expected = NfFailure(
          messageId: MessageIds.UNEXPECTED,
          message: 'Operação falhou: Mensagem original: [Exception: erro]');

      final nfHtmlFromSite = NfHtmlFromSite(html: "html", uf: "MG");

      when(mockNFDataSource.save(nfHtmlFromSite: nfHtmlFromSite))
          .thenThrow(Exception('erro'));
      //act
      final actual = await nfRepository.save(nfHtmlFromSite: nfHtmlFromSite);
      print(actual.fold((l) => l.message, (r) => r));
      //assert
      expect(actual, Left(expected));
    });

    test('should save when everything goes ok', () async {
      //setup
      final expected = NfHtmlFromSite(html: "html", uf: "MG");

      when(mockNFDataSource.save(nfHtmlFromSite: expected))
          .thenAnswer((realInvocation) async => expected);
      //act
      final actual = await nfRepository.save(nfHtmlFromSite: expected);
      //assert
      expect(actual, Right(expected));
    });
  });
}
