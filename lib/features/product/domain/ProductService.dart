import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductPrices.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import 'ProductSearchModel.dart';

abstract class ProductService {
  Future<Either<ProductFailure, List<ProductSearchModel>>> listProductsByText(
      {@required String text});

  Future<Either<ProductFailure, ProductPrices>>
      getMinPriceProductByUserByProductIdUseCase({@required String productId});

  Future<Either<Failure, Stream<ProductPrices>>>
      getPricesProductByUserByProductId({String productId});
}
