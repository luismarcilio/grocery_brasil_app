import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/apisDetails/data/FunctionsDetailsDataSource.dart';
import 'package:grocery_brasil_app/features/apisDetails/domain/BackendFunctionsConfiguration.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/AuthenticationDataSource.dart';
import 'package:grocery_brasil_app/features/secrets/data/SecretDataSource.dart';
import 'package:grocery_brasil_app/features/secrets/data/SecretDataSourceImpl.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockFunctionsDetailsDataSource extends Mock
    implements FunctionsDetailsDataSource {}

class MockHttpClient extends Mock implements http.Client {}

class MockAuthenticationDataSource extends Mock
    implements AuthenticationDataSource {}

class MockHttpResponse extends Mock implements http.Response {}

main() {
  MockFunctionsDetailsDataSource mockFunctionsDetailsDataSource;
  MockHttpClient mockHttpClient;
  MockAuthenticationDataSource mockAuthenticationDataSource;
  SecretDataSource sut;

  group('SecretDataSourceImpl', () {
    setUp(() {
      mockFunctionsDetailsDataSource = MockFunctionsDetailsDataSource();
      mockHttpClient = MockHttpClient();
      mockAuthenticationDataSource = MockAuthenticationDataSource();
      sut = SecretDataSourceImpl(
          httpClient: mockHttpClient,
          authenticationDataSource: mockAuthenticationDataSource,
          functionsDetailsDataSource: mockFunctionsDetailsDataSource);
    });

    test('should retrieve a secret ', () async {
      //setup
      final secretValue = 'SOME_SECRET';
      final secretName = 'SOME_SECRET_NAME';
      final backendConfiguration = BackendFunctionsConfiguration(
          scheme: 'https', host: 'someHost', port: 8080, path: 'somePath');
      final jwt = 'someJWT';
      final secretPath = '/secret/$secretName';
      final expectedBody = jsonEncode(Map.from({'secret': secretValue}));
      final expectedResponse = http.Response(expectedBody, 200);
      final Uri uri = Uri(
          scheme: backendConfiguration.scheme,
          host: backendConfiguration.host,
          port: backendConfiguration.port,
          path: '${backendConfiguration.path}$secretPath');
      final Map httpHeaders = Map<String, String>.from({
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
        "Content-Type": "application/json"
      });
      print('exprected uri: $uri');
      print('exprected httpHeaders: $httpHeaders');
      when(mockFunctionsDetailsDataSource.getBackendFunctionsConfiguration())
          .thenAnswer((realInvocation) async => backendConfiguration);
      when(mockAuthenticationDataSource.getJWT())
          .thenAnswer((realInvocation) async => jwt);

      when(mockHttpClient.get(uri.toString(), headers: httpHeaders))
          .thenAnswer((realInvocation) async => expectedResponse);

      //act
      final actual = await sut.getSecret(secretName);
      //assert
      expect(actual, secretValue);
      verify(mockFunctionsDetailsDataSource.getBackendFunctionsConfiguration());
      verify(mockAuthenticationDataSource.getJWT());
      verify(mockHttpClient.get(uri.toString(), headers: httpHeaders));
    });

    test('should return error NOT FOUND when status is 404', () {
      //setup
      final expected = SecretsException(
          messageId: MessageIds.NOT_FOUND, message: 'not found');
      final secretValue = 'SOME_SECRET';
      final secretName = 'SOME_SECRET_NAME';
      final backendConfiguration = BackendFunctionsConfiguration(
          scheme: 'https', host: 'someHost', port: 8080, path: 'somePath');
      final jwt = 'someJWT';
      final secretPath = '/secret/$secretName';
      final expectedBody = jsonEncode(Map.from({'secret': secretValue}));
      final expectedResponse = http.Response(expectedBody, 404);
      final Uri uri = Uri(
          scheme: backendConfiguration.scheme,
          host: backendConfiguration.host,
          port: backendConfiguration.port,
          path: '${backendConfiguration.path}$secretPath');
      final Map httpHeaders = Map<String, String>.from({
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
        "Content-Type": "application/json"
      });

      when(mockFunctionsDetailsDataSource.getBackendFunctionsConfiguration())
          .thenAnswer((realInvocation) async => backendConfiguration);
      when(mockAuthenticationDataSource.getJWT())
          .thenAnswer((realInvocation) async => jwt);
      when(mockHttpClient.get(uri.toString(), headers: httpHeaders))
          .thenAnswer((realInvocation) async => expectedResponse);

      //act
      //assert
      expect(() async => await sut.getSecret(secretName), throwsA(expected));
    });

    test('should retunr UNEXPECTED when some error occurs', () {
      //setup
      final exception = Exception('some error');
      final secretName = 'SOME_SECRET_NAME';
      final expected = SecretsException(
          messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
      when(mockFunctionsDetailsDataSource.getBackendFunctionsConfiguration())
          .thenThrow(exception);
      //act
      //assert
      expect(() async => await sut.getSecret(secretName), throwsA(expected));
    });
  });
}
