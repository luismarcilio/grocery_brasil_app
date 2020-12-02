import 'package:meta/meta.dart';

import '../../../domain/Location.dart';
import 'ProductPrices.dart';

abstract class ProductRepository {
  Future<List<ProductPrices>> listProductPricesByIdByDistanceOrderByUnitPrice(
      {@required Location topLeft,
      @required Location bottomRight,
      @required String productId,
      @required int listSize});
}
