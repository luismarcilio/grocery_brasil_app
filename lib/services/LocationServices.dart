import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'apiConfiguration.dart' as apiConfiguration;

String _geolocationApiKey;

class GeolocationSuggestion {
  String description;
  String placeId;

  GeolocationSuggestion({this.description, this.placeId});

  factory GeolocationSuggestion.fromJson(Map<String, dynamic> json) =>
      GeolocationSuggestion(
          description: json['description'], placeId: json['place_id']);
}

Future<String> _getGeoLocationApiKey() async {
  if (_geolocationApiKey != null) {
    return _geolocationApiKey;
  }
  final jwt = await FirebaseAuth.instance.currentUser.getIdToken(true);
  await apiConfiguration.initializeApiConfiguration();
  final Uri uri = Uri(
      scheme: apiConfiguration.scheme,
      host: apiConfiguration.host,
      port: apiConfiguration.port,
      path: '${apiConfiguration.path}/geolocationApiKey');
  print("uri: ${uri.toString()}");
  final http.Response response = await http.get(uri.toString(), headers: {
    HttpHeaders.authorizationHeader: 'Bearer $jwt',
    "Content-Type": "application/json"
  });

  print("response: " + response.statusCode.toString());

  _geolocationApiKey = jsonDecode(response.body)['geolocationApiKey'];
  return _geolocationApiKey;
}

Future<Position> getPosition() async {
  Position position = await getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best, timeLimit: Duration(seconds: 10));
  return position;
}

Future<List<GeolocationSuggestion>> getGeolocationAutocompleteSuggestion(
    String key) async {
  print('getGeolocationAutocompleteSuggestion($key)');
  final String geolocationApiKey = await _getGeoLocationApiKey();
  final Position position = await getPosition();
  final Uri uri = Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      port: 443,
      path: 'maps/api/place/autocomplete/json',
      queryParameters: {
        'input': key,
        'sessiontoken': FirebaseAuth.instance.currentUser.uid,
        'location': '${position.latitude},${position.longitude}',
        'key': geolocationApiKey,
        'radius': '100000',
        'language': 'pt-BR'
      });
  print("uri: ${uri.toString()}");
  final http.Response response =
      await http.get(uri, headers: {"Content-Type": "application/json"});
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch suggestion');
  }
  final result = json.decode(response.body);
  if (result['status'] == 'OK') {
    // compose suggestions in a list
    List<GeolocationSuggestion> suggestions = result['predictions']
        .map<GeolocationSuggestion>((p) => GeolocationSuggestion.fromJson(p))
        .toList();
    return suggestions;
  }
  if (result['status'] == 'ZERO_RESULTS') {
    return [];
  }
  throw Exception(result['error_message']);
}
