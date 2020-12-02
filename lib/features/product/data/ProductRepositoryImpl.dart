import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/Location.dart';
import '../domain/ProductPrices.dart';
import '../domain/ProductRepository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<Either<ProductFailure, Stream<ProductPrices>>>
      listProductsPricesByTextAndLocationUseCase(
          {Location location, String text}) {
    // TODO: implement listProductsPricesByTextAndLocationUseCase
    throw UnimplementedError();
  }

  @override
  Future<List<ProductPrices>> listProductPricesByIdByDistanceOrderByUnitPrice(
      {Location location, int distance, String productId, int listSize}) {
    // TODO: implement listProductPricesByIdByDistanceOrderByUnitPrice
    throw UnimplementedError();
  }
}
