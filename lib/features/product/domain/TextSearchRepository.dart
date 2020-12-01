import 'package:grocery_brasil_app/features/product/domain/ProductSearchModel.dart';

abstract class TextSearchRepository {
  Future<Stream<ProductSearchModel>> listProductsByText(String text);
}
