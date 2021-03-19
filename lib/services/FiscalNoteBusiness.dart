import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'apiConfiguration.dart' as apiConfiguration;

typedef AccessKeyFinder(Uri uri);

const Map<String, AccessKeyFinder> accessKeyFactoryConfiguration = {
  'MG': _findAccessModel1,
  'RJ': _findAccessModel1,
};

Future<http.Response> saveNf(String html, String state) async {
  final Map<String, String> data = {'html': html};
  final jwt = await FirebaseAuth.instance.currentUser.getIdToken(true);
  await apiConfiguration.initializeApiConfiguration();
  final Uri uri = Uri(
      scheme: apiConfiguration.scheme,
      host: apiConfiguration.host,
      port: apiConfiguration.port,
      path: '${apiConfiguration.path}/parseAndSaveNf/${state.toLowerCase()}');
  print("uri: $uri");
  final http.Response response =
      await http.post(uri, body: jsonEncode(data), headers: {
    HttpHeaders.authorizationHeader: 'Bearer $jwt',
    "Content-Type": "application/json"
  });

  print("response: " + response.statusCode.toString());
  print("response: " + response.body);
  return response;
}

String _findAccessModel1(Uri uri) {
  Map<String, String> queryParameters = uri.queryParameters;
  String pParameter = queryParameters['p'];
  String accessKey = pParameter.split('|')[0];
  return accessKey;
}

String _findAccessKey(Uri uri) {
  String _state = _findState(uri);
  print('accessKeyFactoryConfiguration: $accessKeyFactoryConfiguration');
  print(
      'accessKeyFactoryConfiguration[$_state]: ${accessKeyFactoryConfiguration[_state]}');
  return accessKeyFactoryConfiguration[_state](uri);
}

String _findState(Uri uri) {
  List<String> hostParts = uri.host.split('.');
  String state = hostParts[hostParts.length - 3].toUpperCase();
  return state;
}

class FiscalNoteUrlData {
  Uri _uri;
  String _accessKey;
  String _state;
  get accessKey => _accessKey;
  get state => _state;

  FiscalNoteUrlData(String url) {
    _uri = Uri.parse(url);
    _state = _findState(_uri);
    _accessKey = _findAccessKey(_uri);
  }

  Future<Uri> getApiUri() async {
    String _jwt = await FirebaseAuth.instance.currentUser.getIdToken();
    await apiConfiguration.initializeApiConfiguration();
    Map<String, List<String>> queryParameters =
        Map.from(_uri.queryParametersAll);
    queryParameters.addAll({
      'jwt': [_jwt]
    });
    Uri apiUri = Uri(
        scheme: apiConfiguration.scheme,
        userInfo: _uri.userInfo,
        host: apiConfiguration.host,
        port: apiConfiguration.port,
        path: _uri.path,
        queryParameters: queryParameters);
    return apiUri;
  }
}
