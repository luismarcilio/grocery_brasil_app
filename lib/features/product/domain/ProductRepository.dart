import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/Address.dart';
import 'ProductPrices.dart';

abstract class ProductRepository {
  Future<Either<ProductFailure, Stream<ProductPrices>>>
      listProductsPricesByTextAndLocationUseCase(
          {@required Location location, @required String text});
}
