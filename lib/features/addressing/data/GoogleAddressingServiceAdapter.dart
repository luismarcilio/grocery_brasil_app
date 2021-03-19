import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/config.dart';
import '../../../core/errors/exceptions.dart';
import '../../../domain/Address.dart';
import '../../../domain/Location.dart';
import '../../login/data/datasources/AuthenticationDataSource.dart';
import '../../secrets/domain/SecretsService.dart';
import '../domain/Autocomplete.dart';
import 'AddressingServiceAdapter.dart';
import 'GPSServiceAdapter.dart';

class GoogleAddressingServiceAdapter implements AddressingServiceAdapter {
  final SecretsService secretsService;
  final http.Client httpClient;
  final GPSServiceAdapter gPSServiceAdapter;
  final AuthenticationDataSource authenticationDataSource;

  GoogleAddressingServiceAdapter(
      {@required this.secretsService,
      @required this.httpClient,
      @required this.gPSServiceAdapter,
      @required this.authenticationDataSource});

  @override
  Future<Address> getAddressByPlaceId(String placeId) async {
    try {
      final apiKey = await secretsService.getSecret('GEOLOCATION_API_KEY');
      final uri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/geocode/json',
          queryParameters: {
            'place_id': placeId,
            'key': apiKey,
            'language': 'pt-BR'
          });
      final response = await httpClient.get(uri).timeout(googleApiTimeout);
      if (response.statusCode != 200) {
        throw AddressingException(
            messageId: MessageIds.UNEXPECTED,
            message: 'Status: ${response.statusCode}');
      }
      final googleResponse = jsonDecode(response.body);
      if (googleResponse['status'] != 'OK') {
        throw AddressingException(
            messageId: MessageIds.UNEXPECTED,
            message:
                "${googleResponse['status']}: ${googleResponse['error_message']}");
      }
      final address = _parseGoogleAddress(googleResponse['results'][0]);
      return address;
    } catch (e) {
      if (e is AddressingException) {
        throw e;
      }
      throw AddressingException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }

  @override
  Future<Address> getAddressFromLocation(Location location) async {
    try {
      final apiKey = await secretsService.getSecret('GEOLOCATION_API_KEY');
      final uri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/geocode/json',
          queryParameters: {
            'latlng': '${location.lat},${location.lon}',
            'key': apiKey,
            'language': 'pt-BR',
            'location_type': 'ROOFTOP',
            'result_type': 'street_address'
          });
      final response = await httpClient.get(uri).timeout(googleApiTimeout);
      if (response.statusCode != 200) {
        throw AddressingException(
            messageId: MessageIds.UNEXPECTED,
            message: 'Status: ${response.statusCode}');
      }
      final googleResponse = jsonDecode(response.body);
      if (googleResponse['status'] != 'OK') {
        throw AddressingException(
            messageId: MessageIds.UNEXPECTED,
            message:
                "${googleResponse['status']}: ${googleResponse['error_message']}");
      }
      final address = _parseGoogleAddress(googleResponse['results'][0]);
      return address;
    } catch (e) {
      if (e is AddressingException) {
        throw e;
      }
      throw AddressingException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }

  @override
  Future<List<Autocomplete>> getAutocomplete(String rawAddress) async {
    try {
      final location = await this.gPSServiceAdapter.getCurrentLocation();
      final apiKey = await this.secretsService.getSecret('GEOLOCATION_API_KEY');
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

      final httpResponse = await httpClient.get(uri).timeout(googleApiTimeout);
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

  Address _parseGoogleAddress(Map<String, dynamic> googleResponse) {
    final emptyLongName = () => Map<String, dynamic>.from({'long_name': ''});
    final emptyShortName = () => Map<String, dynamic>.from({'short_name': ''});
    final List<dynamic> addressComponents =
        googleResponse['address_components'];
    final address = Address(
      rawAddress: googleResponse['formatted_address'],
      street: addressComponents.firstWhere(
          (element) => element['types'].contains('route'),
          orElse: emptyLongName)['long_name'],
      number: addressComponents.firstWhere(
          (element) => element['types'].contains('street_number'),
          orElse: emptyLongName)['long_name'],
      complement: '',
      poCode: addressComponents.firstWhere(
          (element) => element['types'].contains('postal_code'),
          orElse: emptyLongName)['long_name'],
      country: Country(
          name: addressComponents.firstWhere(
              (element) => element['types'].contains('country'),
              orElse: emptyLongName)['long_name']),
      state: State(
          acronym: addressComponents.firstWhere(
              (element) =>
                  element['types'].contains('administrative_area_level_1'),
              orElse: emptyShortName)['short_name'],
          name: addressComponents.firstWhere(
              (element) =>
                  element['types'].contains('administrative_area_level_1'),
              orElse: emptyLongName)['long_name']),
      city: City(
          name: addressComponents.firstWhere(
              (element) =>
                  element['types'].contains('administrative_area_level_2'),
              orElse: emptyLongName)['long_name']),
      county: addressComponents.firstWhere(
          (element) => element['types'].contains('sublocality_level_1'),
          orElse: emptyLongName)['long_name'],
      location: Location(
          lat: googleResponse['geometry']['location']['lat'],
          lon: googleResponse['geometry']['location']['lng']),
    );
    return address;
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
