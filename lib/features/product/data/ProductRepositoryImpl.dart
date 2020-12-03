import 'package:meta/meta.dart';

import '../domain/ProductPrices.dart';
import '../domain/ProductRepository.dart';
import 'ProductDataSource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource productDataSource;

  ProductRepositoryImpl({@required this.productDataSource});

  @override
  Stream<List<ProductPrices>> listProductPricesByIdByGeohashOrderByUnitPrice(
      {String geohash, String productId}) {
    // TODO: implement listProductPricesByIdByGeohashOrderByUnitPrice
    throw UnimplementedError();
  }
}
