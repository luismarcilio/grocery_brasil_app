import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import 'ProductRepository.dart';
import 'ProductSearchModel.dart';
import 'ProductService.dart';
import 'TextSearchRepository.dart';

class ProductServiceImpl implements ProductService {
  final TextSearchRepository textSearchRepository;
  final ProductRepository productRepository;

  ProductServiceImpl(
      {@required this.textSearchRepository, @required this.productRepository});

  @override
  Future<Either<ProductFailure, Stream<ProductSearchModel>>> listProductsByText(
      {String text}) async {
    try {
      final streamOfProducts =
          await textSearchRepository.listProductsByText(text);
      return Right(streamOfProducts);
    } catch (e) {
      if (e is ProductException) {
        return Left(ProductFailure(messageId: e.messageId, message: e.message));
      }
      return Left(ProductFailure(
          messageId: MessageIds.UNEXPECTED, message: e.toString()));
    }
  }
}
