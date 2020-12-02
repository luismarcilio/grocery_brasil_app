import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/product/domain/GetMinPriceProductByUserByProductIdUseCase.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductPrices.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductService.dart';
import 'package:mockito/mockito.dart';
import 'fixture.dart' as fixture;

class MockProductService extends Mock implements ProductService {}

main() {
  MockProductService mockProductService;
  UseCase<ProductPrices, String> sut;

  group('GetMinPriceProductByUserByProductIdUseCase', () {
    setUp(() {
      mockProductService = MockProductService();
      sut = GetMinPriceProductByUserByProductIdUseCase(
          productService: mockProductService);
    });

    test('should call  ProductService.getMinPriceProductByUserByProductId',
        () async {
      //setup
      final expected = fixture.oneProductPrice;
      final productId = fixture.oneProductPrice.product.eanCode;
      when(mockProductService.getMinPriceProductByUserByProductIdUseCase(
              productId: productId))
          .thenAnswer((realInvocation) async => Right(expected));

      //act
      final actual = await sut(productId);

      //assert
      expect(actual, Right(expected));
    });
  });
}
