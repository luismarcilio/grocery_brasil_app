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
            '{"endpoint": "http://someEndpoint","apiId":  "someBackEndKey"}';
        final expectedHeaders = Map<String, String>();
        expectedHeaders['Content-Type'] = 'application/json';
        expectedHeaders['x-api-key'] = 'someBackEndKey';
        final expectedUri = Uri.parse('http://someEndpoint/product?text=leite');
        final expected = fixture.expected;
        final expectedResponse =
            http.Response(fixture.returnFromTextSearch, 200);
        when(mockSecretsService.getSecret('TEXT_SEARCH_API_ID'))
            .thenAnswer((realInvocation) async => secret);
        when(mockHttpClient.get(expectedUri, headers: expectedHeaders))
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
            '{"endpoint": "http://someEndpoint","apiId":  "someBackEndKey"}';
        final expectedHeaders = Map<String, String>();
        expectedHeaders['Content-Type'] = 'application/json';
        expectedHeaders['x-api-key'] = 'someBackEndKey';
        final expectedUri = Uri.parse('http://someEndpoint/product?text=leite');
        final expected = ProductException(
            messageId: MessageIds.UNEXPECTED,
            message: 'Status: 400 - Bad Request This is an error');
        final expectedResponse = http.Response(fixture.failFromTextSearch, 400);
        when(mockSecretsService.getSecret('TEXT_SEARCH_API_ID'))
            .thenAnswer((realInvocation) async => secret);
        when(mockHttpClient.get(expectedUri, headers: expectedHeaders))
            .thenAnswer((realInvocation) async => expectedResponse);
        //act
        //assert
        expect(
            () async => await sut.listProductsByText(text), throwsA(expected));
      });

      test('should throw ProductException if an exception occurs ', () {
        //setup
        final text = 'leite';
        when(mockSecretsService.getSecret('TEXT_SEARCH_API_ID'))
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
