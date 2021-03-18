import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Unity.dart';
import 'package:grocery_brasil_app/features/addressing/data/GPSServiceAdapter.dart';
import 'package:grocery_brasil_app/features/addressing/data/GeohashServiceAdapter.dart';
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

class MockGPSServiceAdapter extends Mock implements GPSServiceAdapter {}

class MockGeohashServiceAdapter extends Mock implements GeohashServiceAdapter {}

main() {
  MockTextSearchRepository mockTextSearchRepository;
  MockProductRepository mockProductRepository;
  MockUserService mockUserService;
  MockGPSServiceAdapter mockGPSServiceAdapter;
  MockGeohashServiceAdapter mockGeohashServiceAdapter;
  ProductService sut;

  group('ProductServiceImpl', () {
    setUp(() {
      mockTextSearchRepository = MockTextSearchRepository();
      mockProductRepository = MockProductRepository();
      mockUserService = MockUserService();
      mockGPSServiceAdapter = MockGPSServiceAdapter();
      mockGeohashServiceAdapter = MockGeohashServiceAdapter();
      sut = ProductServiceImpl(
          productRepository: mockProductRepository,
          textSearchRepository: mockTextSearchRepository,
          userService: mockUserService,
          geohashServiceAdapter: mockGeohashServiceAdapter,
          gPSServiceAdapter: mockGPSServiceAdapter);
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
        when(mockGeohashServiceAdapter.proximityGeohashes(
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(['geohash1', 'geohash2', 'geohash3']);
        when(mockProductRepository
                .listProductPricesByIdByGeohashOrderByUnitPrice(
                    geohashList: ['geohash1', 'geohash2', 'geohash3'],
                    productId: productId))
            .thenAnswer((realInvocation) => Stream.fromIterable([
                  [fixture.oneProductPrice],
                  [fixture.otherProductPrice]
                ]));
        when(mockGeohashServiceAdapter.inCircleCheck(
                fixture.oneProductPrice.company.address.location,
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(true);
        when(mockGeohashServiceAdapter.inCircleCheck(
                fixture.otherProductPrice.company.address.location,
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(true);
        //act
        final actual = await sut.getMinPriceProductByUserByProductIdUseCase(
            productId: productId);
        //assert
        expect(actual, Right(expected));
      });

      test('should remove products not in distance range  ', () async {
        //setup
        final productId = 'SomeProduct';
        final expected = fixture.otherProductPrice;
        final someUser = fixture.oneUser;
        when(mockUserService.getUser())
            .thenAnswer((realInvocation) async => Right(someUser));

        when(mockGeohashServiceAdapter.proximityGeohashes(
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(['geohash1', 'geohash2', 'geohash3']);
        when(mockProductRepository
                .listProductPricesByIdByGeohashOrderByUnitPrice(
                    geohashList: ['geohash1', 'geohash2', 'geohash3'],
                    productId: productId))
            .thenAnswer((realInvocation) => Stream.fromIterable([
                  [fixture.oneProductPrice],
                  [fixture.otherProductPrice]
                ]));
        when(mockGeohashServiceAdapter.inCircleCheck(
                fixture.oneProductPrice.company.address.location,
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(false);
        when(mockGeohashServiceAdapter.inCircleCheck(
                fixture.otherProductPrice.company.address.location,
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(true);
        //act
        final actual = await sut.getMinPriceProductByUserByProductIdUseCase(
            productId: productId);
        //assert
        expect(actual, Right(expected));
      });

      test(
          'should return Failure(not found) when no products are in distance range',
          () async {
        //setup
        final productId = 'SomeProduct';
        final expected = ProductFailure(
            messageId: MessageIds.NOT_FOUND,
            message:
                "Product $productId not found within ${fixture.oneUser.preferences.searchRadius} meters");

        final someUser = fixture.oneUser;
        when(mockUserService.getUser())
            .thenAnswer((realInvocation) async => Right(someUser));

        when(mockGeohashServiceAdapter.proximityGeohashes(
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(['geohash1', 'geohash2', 'geohash3']);
        when(mockProductRepository
                .listProductPricesByIdByGeohashOrderByUnitPrice(
                    geohashList: ['geohash1', 'geohash2', 'geohash3'],
                    productId: productId))
            .thenAnswer((realInvocation) => Stream.fromIterable([
                  [fixture.oneProductPrice],
                  [fixture.otherProductPrice]
                ]));
        when(mockGeohashServiceAdapter.inCircleCheck(
                fixture.oneProductPrice.company.address.location,
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(false);
        when(mockGeohashServiceAdapter.inCircleCheck(
                fixture.otherProductPrice.company.address.location,
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(false);
        //act
        final actual = await sut.getMinPriceProductByUserByProductIdUseCase(
            productId: productId);
        //assert
        expect(actual, Left(expected));
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

    group('getPricesProductByUserByProductId', () {
      test('should retrieve the productPrice stream  ', () async {
        //setup
        final productId = fixture.oneProductPrice.product.eanCode;
        final someUser = fixture.oneUser;
        when(mockUserService.getUser())
            .thenAnswer((realInvocation) async => Right(someUser));
        when(mockGeohashServiceAdapter.proximityGeohashes(
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(['geohash1', 'geohash2', 'geohash3']);
        when(mockProductRepository
                .listProductPricesByIdByGeohashOrderByUnitPrice(
                    geohashList: ['geohash1', 'geohash2', 'geohash3'],
                    productId: productId))
            .thenAnswer((realInvocation) => Stream.fromIterable([
                  [fixture.oneProductPrice],
                  [fixture.otherProductPrice]
                ]));
        when(mockGeohashServiceAdapter.inCircleCheck(
                fixture.oneProductPrice.company.address.location,
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(true);
        when(mockGeohashServiceAdapter.inCircleCheck(
                fixture.otherProductPrice.company.address.location,
                someUser.address.location,
                someUser.preferences.searchRadius.toDouble()))
            .thenReturn(true);
        //act
        final actual =
            await sut.getPricesProductByUserByProductId(productId: productId);
        //assert
        assert(actual.isRight(), true);
        actual.fold(
            (l) => null,
            (r) => expect(
                r,
                emitsInOrder(
                    {fixture.oneProductPrice, fixture.otherProductPrice})));
      });
    });
  });
}
