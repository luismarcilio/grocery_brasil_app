import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/config.dart';
import '../../../core/errors/exceptions.dart';
import '../../apisDetails/data/FunctionsDetailsDataSource.dart';
import '../../apisDetails/domain/BackendFunctionsConfiguration.dart';
import '../../login/data/datasources/AuthenticationDataSource.dart';
import 'SecretDataSource.dart';

class SecretDataSourceImpl implements SecretDataSource {
  final FunctionsDetailsDataSource functionsDetailsDataSource;
  final AuthenticationDataSource authenticationDataSource;
  final http.Client httpClient;

  SecretDataSourceImpl(
      {@required this.functionsDetailsDataSource,
      @required this.authenticationDataSource,
      @required this.httpClient});

  @override
  Future<String> getSecret(String secretName) async {
    try {
      final BackendFunctionsConfiguration backendFunctionsConfiguration =
          await functionsDetailsDataSource.getBackendFunctionsConfiguration();
      final String jwt = await authenticationDataSource.getJWT();

      final Uri uri = Uri(
          scheme: backendFunctionsConfiguration.scheme,
          host: backendFunctionsConfiguration.host,
          port: backendFunctionsConfiguration.port,
          path: '${backendFunctionsConfiguration.path}/secret/$secretName');

      final Map httpHeaders = Map<String, String>.from({
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
        "Content-Type": "application/json"
      });

      final http.Response response = await httpClient
          .get(uri.toString(), headers: httpHeaders)
          .timeout(serverlessFunction);

      if (response.statusCode == 404) {
        throw SecretsException(
            messageId: MessageIds.NOT_FOUND, message: 'not found');
      }

      if (response.statusCode != 200) {
        throw SecretsException(
            messageId: MessageIds.UNEXPECTED,
            message: '${response.statusCode}: ${response.body}');
      }

      print("response.body: ${response.body}");
      final body = jsonDecode(response.body);
      return body['secretValue'];
    } catch (e) {
      if (e is SecretsException) {
        throw e;
      }
      throw new SecretsException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }
}
