import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/config.dart';
import '../../../core/errors/exceptions.dart';
import '../../apisDetails/data/FunctionsDetailsDataSource.dart';
import '../../apisDetails/domain/BackendFunctionsConfiguration.dart';
import '../../login/data/datasources/AuthenticationDataSource.dart';
import '../domain/model/NFProcessData.dart';

abstract class DetailsFromUrlDataSource {
  Future<NFProcessData> call({@required String url});
}

class DetailsFromUrlDataSourceImpl extends DetailsFromUrlDataSource {
  final FunctionsDetailsDataSource functionsDetailsDataSource;
  final AuthenticationDataSource authenticationDataSource;
  final http.Client httpClient;

  DetailsFromUrlDataSourceImpl(
      {@required this.authenticationDataSource,
      @required this.functionsDetailsDataSource,
      @required this.httpClient});

  @override
  Future<NFProcessData> call({@required String url}) async {
    BackendFunctionsConfiguration backendFunctionsConfiguration =
        await functionsDetailsDataSource.getBackendFunctionsConfiguration();
    String jwt = await authenticationDataSource.getJWT();
    final functionPath =
        '${backendFunctionsConfiguration.path}/nfDataByInitialUrl';
    final Map queryString = Map<String, dynamic>.from({'url': url});

    final Uri uri = Uri(
        scheme: backendFunctionsConfiguration.scheme,
        host: backendFunctionsConfiguration.host,
        port: backendFunctionsConfiguration.port,
        path: functionPath,
        queryParameters: queryString);

    print('uri: ${uri.toString()}');
    final Map httpHeaders = Map<String, String>.from({
      HttpHeaders.authorizationHeader: 'Bearer $jwt',
      "Content-Type": "application/json"
    });

    final response = await httpClient
        .get(uri, headers: httpHeaders)
        .timeout(serverlessFunction);

    if (response.statusCode != 200) {
      throw NFReaderException(
          messageId: MessageIds.UNEXPECTED,
          message: '${response.statusCode}: ${response.body}');
    }
    print("response.body: ${response.body}");
    NFProcessData nFProcessData =
        NFProcessData.fromJson(jsonDecode(response.body));
    return nFProcessData;
  }
}
