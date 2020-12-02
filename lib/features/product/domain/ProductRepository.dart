import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/Location.dart';
import 'ProductPrices.dart';

abstract class ProductRepository {
  Future<Either<ProductFailure, Stream<ProductPrices>>>
      listProductsPricesByTextAndLocationUseCase(
          {@required Location location, @required String text});
  Future<List<ProductPrices>> listProductPricesByIdByDistanceOrderByUnitPrice(
      {@required Location location,
      @required int distance,
      @required String productId,
      @required int listSize});
}
