import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/product/domain/GetPricesProductByUserByProductIdUseCase.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductPrices.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductService.dart';
import 'package:mockito/mockito.dart';
import 'fixture.dart' as fixture;

class MockProductService extends Mock implements ProductService {}

main() {
  MockProductService mockProductService;
  UseCase<Stream<ProductPrices>, String> sut;

  group('GetPricesProductByUserByProductIdUseCase', () {
    setUp(() {
      mockProductService = MockProductService();
      sut = GetPricesProductByUserByProductIdUseCase(
          productService: mockProductService);
    });

    test('should call  ProductService.getPricesProductByUserByProductId',
        () async {
      //setup
      final expected = fixture.listOfProductPrices;
      final productId = fixture.oneProductPrice.product.eanCode;
      when(mockProductService.getPricesProductByUserByProductId(
              productId: productId))
          .thenAnswer((realInvocation) async => Right(expected));

      //act
      final actual = await sut(productId);

      //assert
      expect(actual.isRight(), true);
      actual.fold(
          (l) => null,
          (r) => expect(
              r,
              emitsInOrder(
                  {fixture.oneProductPrice, fixture.otherProductPrice})));
    });
  });
}
