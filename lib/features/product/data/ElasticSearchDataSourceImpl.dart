import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/config.dart';
import '../../../core/errors/exceptions.dart';
import '../../secrets/domain/SecretsService.dart';
import '../domain/ProductSearchModel.dart';
import 'TextSearchDataSource.dart';

class ElasticSearchDataSourceImpl implements TextSearchDataSource {
  final http.Client httpClient;
  final SecretsService secretsService;

  ElasticSearchDataSourceImpl(
      {@required this.httpClient, @required this.secretsService});

  @override
  Future<List<ProductSearchModel>> listProductsByText(textToSearch) async {
    try {
      final elasticSearchSecret =
          jsonDecode(await secretsService.getSecret('ELASTICSEARCH'));
      final endpoint = elasticSearchSecret['endpoint'];
      final backEndKey = elasticSearchSecret['backEndKey'];
      final query =
          jsonDecode('{"query": {"match_phrase_prefix": {"name": ""}}}');
      query['query']['match_phrase_prefix']['name'] = textToSearch;
      final url = '$endpoint/produtos_autocomplete/_search';
      final headers = Map<String, String>();
      headers['Content-Type'] = 'application/json';
      headers['Authorization'] = 'ApiKey $backEndKey';
      final queryString = jsonEncode(query);
      final response = await httpClient
          .post(Uri.parse(url), headers: headers, body: queryString)
          .timeout(elasticSearchTimeout);
      if (response.statusCode != 200) {
        String reason = response.reasonPhrase;
        try {
          reason = jsonDecode(response.body)['error']['reason'];
        } catch (e) {}

        throw ProductException(
            messageId: MessageIds.UNEXPECTED,
            message: "Status: ${response.statusCode} : $reason");
      }

      final elResponse = jsonDecode(response.body);
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
    List jsonList = elResponse['hits']['hits'];
    List<ProductSearchModel> products =
        jsonList.map((e) => ProductSearchModel.fromElasticSearch(e)).toList();
    return products;
  }
}
