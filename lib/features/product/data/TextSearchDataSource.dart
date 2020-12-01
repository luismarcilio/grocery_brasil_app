import '../domain/ProductSearchModel.dart';

abstract class TextSearchDataSource {
  Future<List<ProductSearchModel>> listProductsByText(textToSearch);
}
