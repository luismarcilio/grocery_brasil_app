import 'dart:convert';
import 'dart:io';

import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../apisDetails/data/FunctionsDetailsDataSource.dart';
import '../../apisDetails/domain/BackendFunctionsConfiguration.dart';
import '../../login/data/datasources/AuthenticationDataSource.dart';
import '../domain/model/NfHtmlFromSite.dart';

abstract class NFDataSource {
  Future<NfHtmlFromSite> save({@required NfHtmlFromSite nfHtmlFromSite});
}

class NFDataSourceImpl extends NFDataSource {
  final FunctionsDetailsDataSource functionsDetailsDataSource;
  final AuthenticationDataSource authenticationDataSource;
  final http.Client httpClient;

  NFDataSourceImpl(
      {@required this.functionsDetailsDataSource,
      @required this.authenticationDataSource,
      @required this.httpClient})
      : assert(httpClient != null);

  @override
  Future<NfHtmlFromSite> save({NfHtmlFromSite nfHtmlFromSite}) async {
    final BackendFunctionsConfiguration backendFunctionsConfiguration =
        await functionsDetailsDataSource.getBackendFunctionsConfiguration();
    final String jwt = await authenticationDataSource.getJWT();
    final Map<String, String> data = {'html': nfHtmlFromSite.html};

    final Uri uri = Uri(
        scheme: backendFunctionsConfiguration.scheme,
        host: backendFunctionsConfiguration.host,
        port: backendFunctionsConfiguration.port,
        path:
            '${backendFunctionsConfiguration.path}/parseAndSaveNf/${nfHtmlFromSite.uf.toLowerCase()}');
    print("uri: ${uri.toString()}");

    final Map httpHeaders = Map<String, String>.from({
      HttpHeaders.authorizationHeader: 'Bearer $jwt',
      "Content-Type": "application/json"
    });
    final http.Response response = await httpClient.post(uri.toString(),
        body: jsonEncode(data), headers: httpHeaders);

    if (response.statusCode != 200) {
      throw NfException(
          messageId: MessageIds.UNEXPECTED,
          message: '${response.statusCode}: ${response.body}');
    }
    print("response.body: ${response.body}");
    return nfHtmlFromSite;
  }
}
