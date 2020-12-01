import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/Unity.dart';
import 'package:grocery_brasil_app/features/product/data/TextSearchDataSource.dart';
import 'package:grocery_brasil_app/features/product/data/TextSearchRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductSearchModel.dart';
import 'package:grocery_brasil_app/features/product/domain/TextSearchRepository.dart';
import 'package:mockito/mockito.dart';

class MockTextSearchDataSource extends Mock implements TextSearchDataSource {}

main() {
  MockTextSearchDataSource mockTextSearchDataSource;
  TextSearchRepository sut;
  group('TextSearchRepositoryImpl', () {
    setUp(() {
      mockTextSearchDataSource = new MockTextSearchDataSource();
      sut = TextSearchRepositoryImpl(
          textSearchDataSource: mockTextSearchDataSource);
    });
    group('listProductsByText', () {
      test('should return the list of products ', () async {
        //setup
        final textToSearch = 'leite';
        final expected = [
          ProductSearchModel(
              eanCode: '34109823',
              name: 'Leite italac',
              ncmCode: '98723942',
              normalized: true,
              thumbnail: 'http://something',
              unity: Unity(name: 'UN')),
          ProductSearchModel(
              eanCode: '21341223',
              name: 'Leite parmalat',
              ncmCode: '98723942',
              normalized: true,
              thumbnail: 'http://something',
              unity: Unity(name: 'CX')),
          ProductSearchModel(
              eanCode: '1321423',
              name: 'Leite centenario',
              ncmCode: '98723942',
              normalized: true,
              thumbnail: 'http://something',
              unity: Unity(name: 'UN')),
          ProductSearchModel(
              eanCode: '',
              name: 'Leite de  vaca mesmo',
              ncmCode: '98723942',
              normalized: true,
              thumbnail: 'http://something',
              unity: Unity(name: 'LT')),
        ];
        when(mockTextSearchDataSource.listProductsByText(textToSearch))
            .thenAnswer((realInvocation) async => expected);
        //act
        final actual = await sut.listProductsByText(textToSearch);
        //assert
        expect(actual, expected);
      });

      test('should throw ProductException if some error occurs ', () async {
        //setup
        final textToSearch = 'leite';
        final expected = ProductException(
            messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
        when(mockTextSearchDataSource.listProductsByText(textToSearch))
            .thenThrow(Exception('some error'));
        //act
        expect(() async => await sut.listProductsByText(textToSearch),
            throwsA(expected));
      });
    });
  });
}
