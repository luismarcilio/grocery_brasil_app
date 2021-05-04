import 'ProductSearchModel.dart';

abstract class TextSearchRepository {
  Future<List<ProductSearchModel>> listProductsByText(String text);
}
