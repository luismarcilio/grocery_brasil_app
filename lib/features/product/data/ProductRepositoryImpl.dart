import 'package:meta/meta.dart';

import '../../../domain/Location.dart';
import '../domain/ProductPrices.dart';
import '../domain/ProductRepository.dart';
import 'ProductDataSource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource productDataSource;

  ProductRepositoryImpl({@required this.productDataSource});

  @override
  Future<List<ProductPrices>> listProductPricesByIdByDistanceOrderByUnitPrice(
      {Location topLeft,
      Location bottomRight,
      String productId,
      int listSize}) {
    return productDataSource.listProductPricesByIdByDistanceOrderByUnitPrice(
        topLeft: topLeft,
        bottomRight: bottomRight,
        productId: productId,
        listSize: listSize);
  }
}
