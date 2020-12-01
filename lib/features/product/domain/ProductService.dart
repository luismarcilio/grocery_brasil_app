import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import 'ProductSearchModel.dart';

abstract class ProductService {
  Future<Either<ProductFailure, Stream<ProductSearchModel>>> listProductsByText(
      {@required String text});
}
