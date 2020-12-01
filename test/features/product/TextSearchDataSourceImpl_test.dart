import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/product/data/TextSearchDataSource.dart';
import 'package:grocery_brasil_app/features/product/data/TextSearchDataSourceImpl.dart';
import 'package:grocery_brasil_app/features/secrets/domain/SecretsService.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'fixture.dart' as fixture;

class MockHttpClient extends Mock implements http.Client {}

class MockSecretsService extends Mock implements SecretsService {}

main() {
  MockHttpClient mockHttpClient;
  MockSecretsService mockSecretsService;
  TextSearchDataSource sut;

  group('TextSearchDataSourceImpl', () {
    setUp(() {
      mockHttpClient = MockHttpClient();
      mockSecretsService = MockSecretsService();
      sut = TextSearchDataSourceImpl(
          httpClient: mockHttpClient, secretsService: mockSecretsService);
    });

    group('listProductsByText', () {
      test('should return a list of products ', () async {
        //setup
        final text = 'leite';
        final secret =
            '{"endpoint": "http://someEndpoint","backEndKey": "someBackEndKey","frontEndKey": "someFrontEndKey"}';
        final expectedQuery =
            '{"query":{"match_phrase_prefix":{"name":"leite"}}}';

        final expectedUrl = 'http://someEndpoint/produtos_autocomplete/_search';
        final expectedHeaders = Map<String, String>();
        expectedHeaders['Content-Type'] = 'application/json';
        expectedHeaders['Authorization'] = 'ApiKey someBackEndKey';
        final expected = fixture.expected;
        final expectedResponse =
            http.Response(fixture.returnFromElasticSearch, 200);
        when(mockSecretsService.getSecret('ELASTICSEARCH'))
            .thenAnswer((realInvocation) async => secret);
        when(mockHttpClient.post(expectedUrl,
                headers: expectedHeaders, body: expectedQuery))
            .thenAnswer((realInvocation) async => expectedResponse);

        //act
        final actual = await sut.listProductsByText(text);
        //assert
        expect(actual, expected);
      });
      test('should throw ProductException if it does not return status 200 ',
          () async {
        //setup
        final text = 'leite';
        final secret =
            '{"endpoint": "http://someEndpoint","backEndKey": "someBackEndKey","frontEndKey": "someFrontEndKey"}';
        final expectedQuery =
            '{"query":{"match_phrase_prefix":{"name":"leite"}}}';
        final expectedUrl = 'http://someEndpoint/produtos_autocomplete/_search';
        final expectedHeaders = Map<String, String>();
        expectedHeaders['Content-Type'] = 'application/json';
        expectedHeaders['Authorization'] = 'ApiKey someBackEndKey';
        final expected = ProductException(
            messageId: MessageIds.UNEXPECTED,
            message: 'Status: 404 : no such index [produtos_autocomplet]');
        final expectedResponse =
            http.Response(fixture.failFromElasticSearch, 404);
        when(mockSecretsService.getSecret('ELASTICSEARCH'))
            .thenAnswer((realInvocation) async => secret);
        when(mockHttpClient.post(expectedUrl,
                headers: expectedHeaders, body: expectedQuery))
            .thenAnswer((realInvocation) async => expectedResponse);
        //act
        //assert
        expect(
            () async => await sut.listProductsByText(text), throwsA(expected));
      });

      test('should throw ProductException if an exception occurs ', () {
        //setup
        final text = 'leite';
        when(mockSecretsService.getSecret('ELASTICSEARCH'))
            .thenThrow(Exception('some error'));
        final expected = ProductException(
            messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
        //act
        //assert
        expect(
            () async => await sut.listProductsByText(text), throwsA(expected));
      });
    });
  });
}
