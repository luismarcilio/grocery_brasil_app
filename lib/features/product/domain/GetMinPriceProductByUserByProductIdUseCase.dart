import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'ProductPrices.dart';
import 'ProductService.dart';

class GetMinPriceProductByUserByProductIdUseCase
    implements UseCase<ProductPrices, String> {
  final ProductService productService;

  GetMinPriceProductByUserByProductIdUseCase({@required this.productService});
  @override
  Future<Either<Failure, ProductPrices>> call(String productId) {
    return productService.getMinPriceProductByUserByProductIdUseCase(
        productId: productId);
  }
}
