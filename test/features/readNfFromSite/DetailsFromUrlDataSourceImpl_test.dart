import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/apisDetails/data/FunctionsDetailsDataSource.dart';
import 'package:grocery_brasil_app/features/apisDetails/domain/BackendFunctionsConfiguration.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/AuthenticationDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/DetailsFromUrlDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NFProcessData.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockFunctionsDetailsDataSource extends Mock
    implements FunctionsDetailsDataSource {}

class MockAuthenticationDataSource extends Mock
    implements AuthenticationDataSource {}

class MockHttp extends Mock implements http.Client {}

void main() {
  DetailsFromUrlDataSource detailsFromUrlDataSource;

  MockFunctionsDetailsDataSource mockFunctionsDetailsDataSource;
  MockAuthenticationDataSource mockAuthenticationDataSource;
  MockHttp mockHttp;

  setUp(() {
    mockFunctionsDetailsDataSource = MockFunctionsDetailsDataSource();
    mockAuthenticationDataSource = MockAuthenticationDataSource();
    mockHttp = MockHttp();

    detailsFromUrlDataSource = DetailsFromUrlDataSourceImpl(
        authenticationDataSource: mockAuthenticationDataSource,
        functionsDetailsDataSource: mockFunctionsDetailsDataSource,
        httpClient: mockHttp);
  });

  group('DetailsFromUrlDataSource', () {
    test('should return details when everything goes ok', () async {
      //setup

      const String expectedString =
          '{"accessKey": "accessKeyTeste", "initialUrl":"initialUrlTeste", "uf":"stateTeste", "javascriptFunctions":"functionsTeste"}';
      const NFProcessData expected = NFProcessData(
          accessKey: 'accessKeyTeste',
          initialUrl: 'initialUrlTeste',
          javascriptFunctions: 'functionsTeste',
          uf: 'stateTeste');
      when(mockFunctionsDetailsDataSource.getBackendFunctionsConfiguration())
          .thenAnswer((realInvocation) async => BackendFunctionsConfiguration(
              host: 'hostTest',
              path: '/pathTeste',
              port: 666,
              scheme: 'https'));

      when(mockAuthenticationDataSource.getJWT())
          .thenAnswer((realInvocation) async => 'JWT');
      final Map httpHeaders = Map<String, String>.from({
        HttpHeaders.authorizationHeader: 'Bearer JWT',
        "Content-Type": "application/json"
      });

      when(mockHttp.get(
              Uri.parse(
                  "https://hosttest:666/pathTeste/nfDataByInitialUrl?url=http%3A%2F%2Fteste"),
              headers: httpHeaders))
          .thenAnswer(
              (realInvocation) async => http.Response(expectedString, 200));
      //act
      final actual = await detailsFromUrlDataSource(url: 'http://teste');
      //assert
      expect(actual, expected);
    });

    test('should return details when everything goes ok', () async {
      //setup

      final NFReaderException expected = NFReaderException(
          messageId: MessageIds.UNEXPECTED, message: '500: erro');
      when(mockFunctionsDetailsDataSource.getBackendFunctionsConfiguration())
          .thenAnswer((realInvocation) async => BackendFunctionsConfiguration(
              host: 'hostTest',
              path: '/pathTeste',
              port: 666,
              scheme: 'https'));

      when(mockAuthenticationDataSource.getJWT())
          .thenAnswer((realInvocation) async => 'JWT');
      final Map httpHeaders = Map<String, String>.from({
        HttpHeaders.authorizationHeader: 'Bearer JWT',
        "Content-Type": "application/json"
      });

      when(mockHttp.get(
              Uri.parse(
                  "https://hosttest:666/pathTeste/nfDataByInitialUrl?url=http%3A%2F%2Fteste"),
              headers: httpHeaders))
          .thenAnswer((realInvocation) async => http.Response('erro', 500));
      //act
      expect(() async => await detailsFromUrlDataSource(url: 'http://teste'),
          throwsA(expected));
    });
  });
}
