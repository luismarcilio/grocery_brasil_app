import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../domain/ProductSearchModel.dart';
import '../domain/TextSearchRepository.dart';
import 'TextSearchDataSource.dart';

class TextSearchRepositoryImpl implements TextSearchRepository {
  final TextSearchDataSource textSearchDataSource;

  TextSearchRepositoryImpl({@required this.textSearchDataSource});

  @override
  Future<List<ProductSearchModel>> listProductsByText(String text) {
    try {
      return textSearchDataSource.listProductsByText(text);
    } catch (e) {
      if (e is ProductException) {
        throw e;
      }
      throw ProductException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }
}
