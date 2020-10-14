import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/apisDetails/data/FunctionsDetailsDataSource.dart';
import 'package:grocery_brasil_app/features/apisDetails/domain/BackendFunctionsConfiguration.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/AuthenticationDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/NFDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NfHtmlFromSite.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockFunctionsDetailsDataSource extends Mock
    implements FunctionsDetailsDataSource {}

class MockAuthenticationDataSource extends Mock
    implements AuthenticationDataSource {}

class MockHttp extends Mock implements http.Client {}

void main() {
  NFDataSource nFDataSource;

  MockFunctionsDetailsDataSource mockFunctionsDetailsDataSource;
  MockAuthenticationDataSource mockAuthenticationDataSource;
  MockHttp mockHttp;

  setUp(() {
    mockFunctionsDetailsDataSource = MockFunctionsDetailsDataSource();
    mockAuthenticationDataSource = MockAuthenticationDataSource();
    mockHttp = MockHttp();

    nFDataSource = NFDataSourceImpl(
        authenticationDataSource: mockAuthenticationDataSource,
        functionsDetailsDataSource: mockFunctionsDetailsDataSource,
        httpClient: mockHttp);
  });

  group('NFDataSource.save', () {
    test('should save when everything is ok', () async {
      //setup

      const String expectedString = 'OK';
      final NfHtmlFromSite expected = NfHtmlFromSite(html: "html", uf: 'MG');
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
      when(mockHttp.post(anything,
              body: '{"html":"html"}', headers: httpHeaders))
          .thenAnswer(
              (realInvocation) async => http.Response(expectedString, 200));
      //act
      final actual = await nFDataSource.save(nfHtmlFromSite: expected);
      //assert
      expect(actual, expected);
    });

    test('should throw PurchaseException in case of error', () async {
      //setup

      final PurchaseException expected = PurchaseException(
          messageId: MessageIds.UNEXPECTED, message: '500: erro');
      final NfHtmlFromSite nfHtmlFromSite =
          NfHtmlFromSite(html: "html", uf: 'MG');

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

      when(mockHttp.post(anything, body: anything, headers: httpHeaders))
          .thenAnswer((realInvocation) async => http.Response('erro', 500));
      //act
      expect(
          () async => await nFDataSource.save(nfHtmlFromSite: nfHtmlFromSite),
          throwsA(expected));
    });
  });
}
