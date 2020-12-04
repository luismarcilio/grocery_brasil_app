import 'package:meta/meta.dart';

import '../domain/ProductPrices.dart';
import '../domain/ProductRepository.dart';
import 'ProductDataSource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource productDataSource;

  ProductRepositoryImpl({@required this.productDataSource});

  @override
  Stream<List<ProductPrices>> listProductPricesByIdByGeohashOrderByUnitPrice(
      {List<String> geohashList, String productId}) {
    return productDataSource.listProductPricesByIdByGeohashOrderByUnitPrice(
        geohashList: geohashList, productId: productId);
  }
}
