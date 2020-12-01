import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/features/product/domain/ListProductsPricesByTextAndLocationUseCase.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductPrices.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductService.dart';
import 'package:mockito/mockito.dart';

class MockProductService extends Mock implements ProductService {}

main() {
  MockProductService mockProductService;
  ListProductsPricesByTextAndLocationUseCase
      listProductsPricesByTextAndLocationUseCase;

  setUp(() {
    mockProductService = MockProductService();
    listProductsPricesByTextAndLocationUseCase =
        ListProductsPricesByTextAndLocationUseCase(
            productService: mockProductService);
  });

  group('ListProductsPricesByTextAndLocationUseCase', () {
    test('should return stream of ProductsPrices  ', () async {
      //setup
      final Stream<ProductPrices> streamOfProductPrices =
          Stream<ProductPrices>.fromIterable([ProductPrices()]);
      when(mockProductService.listProductsPricesByTextAndLocationUseCase(
              location: Location(lat: 0.0, lon: 0.0), text: "PRODUTO"))
          .thenAnswer((realInvocation) async => Right(streamOfProductPrices));
      //act
      final actual = await listProductsPricesByTextAndLocationUseCase(
          Params(location: Location(lat: 0.0, lon: 0.0), text: "PRODUTO"));
      //assert
      expect(actual, Right(streamOfProductPrices));
    });
  });
}
