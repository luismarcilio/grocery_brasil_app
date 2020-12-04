import '../domain/ProductPrices.dart';

abstract class ProductDataSource {
  Stream<List<ProductPrices>> listProductPricesByIdByGeohashOrderByUnitPrice(
      {List<String> geohashList, String productId});
}
