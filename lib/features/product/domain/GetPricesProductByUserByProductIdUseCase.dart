import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'ProductPrices.dart';
import 'ProductService.dart';

class GetPricesProductByUserByProductIdUseCase
    implements UseCase<Stream<List<ProductPrices>>, String> {
  final ProductService productService;

  GetPricesProductByUserByProductIdUseCase({@required this.productService});
  @override
  Future<Either<Failure, Stream<List<ProductPrices>>>> call(String productId) {
    return productService.getPricesProductByUserByProductId(
        productId: productId);
  }
}
