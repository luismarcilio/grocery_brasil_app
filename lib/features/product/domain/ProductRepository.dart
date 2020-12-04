import 'package:meta/meta.dart';

import 'ProductPrices.dart';

abstract class ProductRepository {
  Stream<List<ProductPrices>> listProductPricesByIdByGeohashOrderByUnitPrice(
      {@required List<String> geohashList, @required String productId});
}
