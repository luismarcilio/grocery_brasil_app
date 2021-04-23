import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/config.dart';
import '../../../core/errors/exceptions.dart';
import '../../secrets/domain/SecretsService.dart';
import '../domain/ProductSearchModel.dart';
import 'TextSearchDataSource.dart';

class TextSearchDataSourceImpl implements TextSearchDataSource {
  final http.Client httpClient;
  final SecretsService secretsService;

  TextSearchDataSourceImpl(
      {@required this.httpClient, @required this.secretsService});

  @override
  Future<List<ProductSearchModel>> listProductsByText(textToSearch) async {
    try {
      final elasticSearchSecret =
          jsonDecode(await secretsService.getSecret('TEXT_SEARCH_API_ID'));
      final endpoint = elasticSearchSecret['endpoint'];
      final backEndKey = elasticSearchSecret['apiId'];
      final url = '$endpoint/product';
      final headers = Map<String, String>();
      headers['Content-Type'] = 'application/json';
      headers['x-api-key'] = backEndKey;
      final Uri tempUri = Uri.parse(url);
      final Uri uri = new Uri(
          scheme: tempUri.scheme,
          host: tempUri.host,
          port: tempUri.port,
          path: tempUri.path,
          queryParameters: {'text': textToSearch});
      final response = await httpClient
          .get(uri, headers: headers)
          .timeout(elasticSearchTimeout);
      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw ProductException(
            messageId: MessageIds.UNEXPECTED,
            message:
                "Status: ${response.statusCode} - ${body['error']} ${body['message']}");
      }

      final elResponse =
          jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true));
      final List<ProductSearchModel> productList = _parse(elResponse);
      return productList;
    } catch (e) {
      if (e is ProductException) {
        throw e;
      }
      throw ProductException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }

  List<ProductSearchModel> _parse(Map<String, dynamic> elResponse) {
    List jsonList = elResponse['productList'];
    List<ProductSearchModel> products =
        jsonList.map((e) => ProductSearchModel.fromTextSearch(e)).toList();
    return products;
  }
}
