import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/domain/Unity.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductRepository.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductSearchModel.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductService.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductServiceImpl.dart';
import 'package:grocery_brasil_app/features/product/domain/TextSearchRepository.dart';
import 'package:grocery_brasil_app/features/user/domain/UserService.dart';
import 'package:mockito/mockito.dart';
import 'fixture.dart' as fixture;

class MockTextSearchRepository extends Mock implements TextSearchRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockUserService extends Mock implements UserService {}

main() {
  MockTextSearchRepository mockTextSearchRepository;
  MockProductRepository mockProductRepository;
  MockUserService mockUserService;
  ProductService sut;

  group('ProductServiceImpl', () {
    setUp(() {
      mockTextSearchRepository = MockTextSearchRepository();
      mockProductRepository = MockProductRepository();
      mockUserService = MockUserService();
      sut = ProductServiceImpl(
          productRepository: mockProductRepository,
          textSearchRepository: mockTextSearchRepository,
          userService: mockUserService);
    });

    group('listProductsByText', () {
      test('should bring a list of product prices ', () async {
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
        when(mockTextSearchRepository.listProductsByText(textToSearch))
            .thenAnswer((realInvocation) async => expected);
        //act
        final actual = await sut.listProductsByText(text: textToSearch);
        //assert
        expect(actual, Right(expected));
      });
      test('should return ProductFailure if it fails ', () async {
        //setup
        final textToSearch = 'leite';
        final expected = ProductFailure(
            messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
        when(mockTextSearchRepository.listProductsByText(textToSearch))
            .thenThrow(Exception('some error'));
        //act
        final actual = await sut.listProductsByText(text: textToSearch);
        //assert
        expect(actual, Left(expected));
      });
    });

    group('getMinPriceProductByUserByProductIdUseCase', () {
      test('should retrieve the productPrice object  ', () async {
        //setup
        final productId = 'SomeProduct';
        final expected = fixture.oneProductPrice;
        final someUser = fixture.oneUser;
        when(mockUserService.getUser())
            .thenAnswer((realInvocation) async => Right(someUser));
        when(mockProductRepository
                .listProductPricesByIdByDistanceOrderByUnitPrice(
                    topLeft: Location(
                        lat: -22.337196547938802, lon: -43.886949829808195),
                    bottomRight: Location(
                        lat: -23.60898916679005, lon: -42.50546386664078),
                    productId: productId,
                    listSize: 1))
            .thenAnswer((realInvocation) async => [expected]);
        //act
        final actual = await sut.getMinPriceProductByUserByProductIdUseCase(
            productId: productId);
        //assert
        expect(actual, Right(expected));
      });
      test('should return ProductFailure on error  ', () async {
        //setup
        final productId = fixture.oneProductPrice.product.eanCode;
        final expected = ProductFailure(
            messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
        when(mockUserService.getUser()).thenThrow(Exception('some error'));
        //act
        final actual = await sut.getMinPriceProductByUserByProductIdUseCase(
            productId: productId);
        //assert
        expect(actual, Left(expected));
      });
    });
  });
}
