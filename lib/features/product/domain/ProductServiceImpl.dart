import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:meta/meta.dart';
import 'dart:math';
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

      final coordinatePoints = _calculateLocationPoints(
          center: user.address.location,
          distance: user.preferences.searchRadius);

      List<ProductPrices> listProductPrices = await productRepository
          .listProductPricesByIdByDistanceOrderByUnitPrice(
              topLeft: coordinatePoints[0],
              bottomRight: coordinatePoints[1],
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

  List<Location> _calculateLocationPoints({Location center, int distance}) {
    //bearing (clockwise from north)
    final double topLeftBrng = -45.0;
    final double bottomRightBrng = 135.0;
    final topLeft = _calculateCoordinates(
        center: center, distance: distance, bearing: topLeftBrng);
    final bottomRight = _calculateCoordinates(
        center: center, distance: distance, bearing: bottomRightBrng);
    return [topLeft, bottomRight];
  }

  Location _calculateCoordinates(
      {Location center, int distance, double bearing}) {
    //source: https://www.movable-type.co.uk/scripts/latlong.html
    // Formula:	φ2 = asin( sin φ1 ⋅ cos δ + cos φ1 ⋅ sin δ ⋅ cos θ )
    // λ2 = λ1 + atan2( sin θ ⋅ sin δ ⋅ cos φ1, cos δ − sin φ1 ⋅ sin φ2 )
    // where	φ is latitude, λ is longitude, θ is the bearing (clockwise from north), δ is the angular distance d/R;
    // d being the distance travelled, R the earth’s radius

    final double R = 6371.0e3;
    final double phi1 = center.lat / 180 * pi;
    final double lambda1 = center.lon / 180 * pi;
    final double tetha = bearing / 180 * pi;
    final double delta = distance / R;
    final double phi2 =
        asin(sin(phi1) * cos(delta) + cos(phi1) * sin(delta) * cos(tetha));
    final double lambda2 = lambda1 +
        atan2(sin(tetha) * sin(delta) * cos(phi1),
            cos(delta) - sin(phi1) * sin(phi2));
    return Location(lat: 180 * phi2 / pi, lon: 180 * lambda2 / pi);
  }
}
