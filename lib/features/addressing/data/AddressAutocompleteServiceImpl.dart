import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../login/data/datasources/AuthenticationDataSource.dart';
import '../../secrets/data/SecretDataSource.dart';
import '../domain/Autocomplete.dart';
import 'AddressAutocompleteService.dart';
import 'GPSServiceAdapter.dart';

class AddressAutocompleteServiceImpl implements AddressAutocompleteService {
  final SecretDataSource secretDataSource;
  final http.Client httpClient;
  final AuthenticationDataSource authenticationDataSource;
  final GPSServiceAdapter gPSServiceAdapter;

  AddressAutocompleteServiceImpl(
      {@required this.secretDataSource,
      @required this.httpClient,
      @required this.authenticationDataSource,
      @required this.gPSServiceAdapter});

  @override
  Future<List<Autocomplete>> getAutocomplete(String rawAddress) async {
    try {
      final location = await this.gPSServiceAdapter.getCurrentLocation();
      final apiKey =
          await this.secretDataSource.getSecret('GEOLOCATION_API_KEY');
      final userId = this.authenticationDataSource.getUserId();
      final uri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/place/autocomplete/json',
          queryParameters: {
            'input': rawAddress,
            'sessiontoken': userId,
            'location': '${location.lat},${location.lon}',
            'key': apiKey,
            'radius': '100000',
            'language': 'pt-BR'
          });

      final httpResponse =
          await httpClient.get(uri.toString()).timeout(Duration(seconds: 5));
      if (httpResponse.statusCode != 200) {
        throw AddressingException(
            messageId: MessageIds.UNEXPECTED,
            message: 'Server response: ${httpResponse.statusCode}');
      }

      final returnData =
          _mapGoogleAutoCompleteToAutocomplete(httpResponse.body);
      return returnData;
    } catch (e) {
      if (e is AddressingException) {
        throw e;
      }
      throw AddressingException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }

  _mapGoogleAutoCompleteToAutocomplete(String body) {
    final googleAutoComplete = jsonDecode(body);

    if (googleAutoComplete['status'] != 'OK' &&
        googleAutoComplete['status'] != 'ZERO_RESULTS') {
      throw AddressingException(
          messageId: MessageIds.UNEXPECTED,
          message:
              '${googleAutoComplete['status']}: ${googleAutoComplete['error_message']}');
    }
    if (googleAutoComplete['status'] == 'ZERO_RESULTS') {
      return List<Autocomplete>.empty();
    }
    final List predictions = googleAutoComplete['predictions'];
    final List<Autocomplete> autocomplete = predictions
        .map((e) =>
            Autocomplete(description: e['description'], placeId: e['place_id']))
        .toList();
    return autocomplete;
  }
}
