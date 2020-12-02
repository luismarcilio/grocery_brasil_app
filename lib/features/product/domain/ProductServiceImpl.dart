import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/User.dart';
import '../../user/domain/UserService.dart';
import 'ProductPrices.dart';
import 'ProductRepository.dart';
import 'ProductSearchModel.dart';
import 'ProductService.dart';
import 'TextSearchRepository.dart';

class ProductServiceImpl implements ProductService {
  final TextSearchRepository textSearchRepository;
  final ProductRepository productRepository;
  final UserService userService;

  ProductServiceImpl(
      {@required this.textSearchRepository,
      @required this.productRepository,
      @required this.userService});

  @override
  Future<Either<ProductFailure, List<ProductSearchModel>>> listProductsByText(
      {String text}) async {
    try {
      final listOfProducts =
          await textSearchRepository.listProductsByText(text);
      return Right(listOfProducts);
    } catch (e) {
      if (e is ProductException) {
        return Left(ProductFailure(messageId: e.messageId, message: e.message));
      }
      return Left(ProductFailure(
          messageId: MessageIds.UNEXPECTED, message: e.toString()));
    }
  }

  @override
  Future<Either<ProductFailure, ProductPrices>>
      getMinPriceProductByUserByProductIdUseCase({String productId}) async {
    try {
      final result = await userService.getUser();
      if (result.isLeft()) {
        UserFailure userFailure;
        result.fold((l) => userFailure = l, (r) => null);
        return Left(ProductFailure(
            messageId: userFailure.messageId, message: userFailure.message));
      }
      User user;
      result.fold((l) => null, (r) => user = r);
      List<ProductPrices> listProductPrices = await productRepository
          .listProductPricesByIdByDistanceOrderByUnitPrice(
              location: user.address.location,
              distance: user.preferences.searchRadius,
              productId: productId,
              listSize: 1);
      if (listProductPrices.length == 0) {
        return Left(ProductFailure(
            messageId: MessageIds.NOT_FOUND,
            message: 'Product not found: [$productId]'));
      }
      return Right(listProductPrices[0]);
    } catch (e) {
      if (e is ProductException) {
        return (Left(
            ProductFailure(messageId: e.messageId, message: e.message)));
      }
      return (Left(ProductFailure(
          messageId: MessageIds.UNEXPECTED, message: e.toString())));
    }
  }
}
