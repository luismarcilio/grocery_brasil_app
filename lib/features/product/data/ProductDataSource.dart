import '../../../domain/Location.dart';
import '../domain/ProductPrices.dart';

abstract class ProductDataSource {
  Future<List<ProductPrices>> listProductPricesByIdByDistanceOrderByUnitPrice(
      {Location topLeft, Location bottomRight, String productId, int listSize});
}
