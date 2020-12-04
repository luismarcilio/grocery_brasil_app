import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/Location.dart';
import '../../../domain/User.dart';
import '../../addressing/data/GPSServiceAdapter.dart';
import '../../addressing/data/GeohashServiceAdapter.dart';
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
  final GeohashServiceAdapter geohashServiceAdapter;
  final GPSServiceAdapter gPSServiceAdapter;

  ProductServiceImpl(
      {@required this.textSearchRepository,
      @required this.productRepository,
      @required this.userService,
      @required this.geohashServiceAdapter,
      @required this.gPSServiceAdapter});

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

      final geohashList = geohashServiceAdapter.proximityGeohashes(
          user.address.location, user.preferences.searchRadius.toDouble());
      Stream<List<ProductPrices>> productPrices =
          productRepository.listProductPricesByIdByGeohashOrderByUnitPrice(
              geohashList: geohashList, productId: productId);

      final bestProductPrice = await productPrices
          .expand((element) => element)
          .firstWhere(
              (element) => _isInSearchRadius(element, user.address.location,
                  user.preferences.searchRadius), orElse: () {
        throw ProductException(
            messageId: MessageIds.NOT_FOUND,
            message:
                "Product $productId not found within ${user.preferences.searchRadius} meters");
      });
      return Right(bestProductPrice);
    } catch (e) {
      if (e is ProductException) {
        return (Left(
            ProductFailure(messageId: e.messageId, message: e.message)));
      }
      return (Left(ProductFailure(
          messageId: MessageIds.UNEXPECTED, message: e.toString())));
    }
  }

  bool _isInSearchRadius(
      ProductPrices element, Location location, int searchRadius) {
    return geohashServiceAdapter.inCircleCheck(
        element.company.address.location, location, searchRadius.toDouble());
  }
}
