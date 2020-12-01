import 'package:grocery_brasil_app/features/product/domain/ProductSearchModel.dart';

abstract class TextSearchRepository {
  Future<List<ProductSearchModel>> listProductsByText(String text);
}
