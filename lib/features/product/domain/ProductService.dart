import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import 'ProductPrices.dart';
import 'ProductSearchModel.dart';

abstract class ProductService {
  Future<Either<ProductFailure, List<ProductSearchModel>>> listProductsByText(
      {@required String text});

  Future<Either<ProductFailure, ProductPrices>>
      getMinPriceProductByUserByProductIdUseCase({@required String productId});

  Future<Either<Failure, Stream<List<ProductPrices>>>>
      getPricesProductByUserByProductId({String productId});
}
