import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/features/addressing/data/AddressingServiceAdapter.dart';
import 'package:grocery_brasil_app/features/addressing/data/GPSServiceAdapter.dart';
import 'package:grocery_brasil_app/features/addressing/data/GoogleAddressingServiceAdapter.dart';
import 'package:grocery_brasil_app/features/addressing/domain/Autocomplete.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/AuthenticationDataSource.dart';
import 'package:grocery_brasil_app/features/secrets/domain/SecretsService.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'fixtures.dart' as fixtures;

class MockSecretsService extends Mock implements SecretsService {}

class MockGPSServiceAdapter extends Mock implements GPSServiceAdapter {}

class MockHttpClient extends Mock implements http.Client {}

class MockAuthenticationDataSource extends Mock
    implements AuthenticationDataSource {}

main() {
  AddressingServiceAdapter sut;
  MockSecretsService mockSecretsService;
  MockHttpClient mockHttpClient;
  MockGPSServiceAdapter mockGPSServiceAdapter;
  MockAuthenticationDataSource mockAuthenticationDataSource;
  setUp(() {
    mockSecretsService = new MockSecretsService();
    mockHttpClient = new MockHttpClient();
    mockGPSServiceAdapter = new MockGPSServiceAdapter();
    mockAuthenticationDataSource = new MockAuthenticationDataSource();
    sut = GoogleAddressingServiceAdapter(
        httpClient: mockHttpClient,
        secretsService: mockSecretsService,
        gPSServiceAdapter: mockGPSServiceAdapter,
        authenticationDataSource: mockAuthenticationDataSource);
  });

  group('getAddressByPlaceId', () {
    test('should retrieve address when passed a place id', () async {
      //setup
      final aPlaceId = 'placeId';
      final serviceReturns = http.Response(fixtures.placeIdResponse, 200);
      final expected = Address(
          rawAddress:
              "Av. Epitácio Pessoa - Lagoa, Rio de Janeiro - RJ, Brasil",
          street: "Avenida Epitácio Pessoa",
          number: "",
          complement: '',
          poCode: "",
          county: "Lagoa",
          country: Country(name: "Brasil"),
          state: State(name: "Rio de Janeiro", acronym: "RJ"),
          city: City(name: "Rio de Janeiro"),
          location: Location(lat: -22.9708637, lon: -43.2069645));

      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/geocode/json',
          queryParameters: {
            'place_id': aPlaceId,
            'key': 'theGeolocationApiKey',
            'language': 'pt-BR'
          });
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');

      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => serviceReturns);
      //act
      final actual = await sut.getAddressByPlaceId(aPlaceId);
      //assert
      expect(actual, equals(expected));
    });

    test('should throw unexpected when status is not OK', () {
      //setup
      final aPlaceId = 'placeId';
      final serviceReturns = http.Response(fixtures.googleGeocoderError, 200);
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED,
          message: 'REQUEST_DENIED: The provided API key is invalid.');

      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/geocode/json',
          queryParameters: {
            'place_id': aPlaceId,
            'key': 'theGeolocationApiKey',
            'language': 'pt-BR'
          });
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');

      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => serviceReturns);
      //act
      //assert
      expect(() async => await sut.getAddressByPlaceId(aPlaceId),
          throwsA(expected));
    });
    test('should throw unexpected when response <> 200', () {
      //setup
      final aPlaceId = 'placeId';
      final serviceReturns = http.Response(fixtures.googleGeocoderError, 500);
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Status: 500');

      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/geocode/json',
          queryParameters: {
            'place_id': aPlaceId,
            'key': 'theGeolocationApiKey',
            'language': 'pt-BR'
          });
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');

      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => serviceReturns);
      //act
      //assert
      expect(() async => await sut.getAddressByPlaceId(aPlaceId),
          throwsA(expected));
    });

    test('should throw AddressingException when an exception occurs', () {
      //setup
      final aPlaceId = 'placeId';
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenThrow(Exception('some error'));
      //act
      expect(() async => await sut.getAddressByPlaceId(aPlaceId),
          throwsA(expected));
    });
  });

  group('getAutocomplete', () {
    test('should get list of Autocomplete ', () async {
      //setup
      final expected = List<Autocomplete>.from([
        Autocomplete(
            description:
                "Rua Novo Horizonte - Montanhão, São Bernardo do Campo - SP, Brasil",
            placeId:
                "EkRSdWEgTm92byBIb3Jpem9udGUgLSBNb250YW5ow6NvLCBTw6NvIEJlcm5hcmRvIGRvIENhbXBvIC0gU1AsIEJyYXNpbCIuKiwKFAoSCe3CKD3wQc6UEZuecd6OoJUbEhQKEgm5Sqj450HOlBH8WjlCtuJNAA"),
        Autocomplete(
            description:
                "Rua Novo Horizonte da Sussuarana - Novo Horizonte, Salvador - BA, Brasil",
            placeId:
                "EkhSdWEgTm92byBIb3Jpem9udGUgZGEgU3Vzc3VhcmFuYSAtIE5vdm8gSG9yaXpvbnRlLCBTYWx2YWRvciAtIEJBLCBCcmFzaWwiLiosChQKEgkLawaEfhoWBxGP4aQzxESxUhIUChIJG3yFS34aFgcR4WTWoZzv84Y"),
        Autocomplete(
            description:
                "Rua Novo Horizonte - Higienópolis, São Paulo - SP, Brasil",
            placeId:
                "EjtSdWEgTm92byBIb3Jpem9udGUgLSBIaWdpZW7Ds3BvbGlzLCBTw6NvIFBhdWxvIC0gU1AsIEJyYXNpbCIuKiwKFAoSCaFPrHAuWM6UEQONrkKM0EB6EhQKEglVtfr2O1jOlBHd1UzRDYVn9A"),
        Autocomplete(
            description:
                "Rua Novo Horizonte - Jardim Ana Estela, Carapicuíba - SP, Brasil",
            placeId:
                "EkFSdWEgTm92byBIb3Jpem9udGUgLSBKYXJkaW0gQW5hIEVzdGVsYSwgQ2FyYXBpY3XDrWJhIC0gU1AsIEJyYXNpbCIuKiwKFAoSCQOGO7s_AM-UEb7ixU13WGoYEhQKEgk_plOEFQDPlBGG6QXM0x9eAg"),
        Autocomplete(
            description:
                "Rua Novo Horizonte - Liberdade, Parauapebas - PA, Brasil",
            placeId:
                "EjhSdWEgTm92byBIb3Jpem9udGUgLSBMaWJlcmRhZGUsIFBhcmF1YXBlYmFzIC0gUEEsIEJyYXNpbCIuKiwKFAoSCXF9mLjwUN2SEQCdB28TIPGDEhQKEgnDnKHp71DdkhEfZnyejX2W7w"),
      ]);
      final expectedLocation = Location(lat: -19.0, lon: -45.0);
      final input = 'Some part of address';
      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/place/autocomplete/json',
          queryParameters: {
            'input': input,
            'sessiontoken': 'someUserId',
            'location': '${expectedLocation.lat},${expectedLocation.lon}',
            'key': 'theGeolocationApiKey',
            'radius': '100000',
            'language': 'pt-BR'
          });
      final expectedHttpResponse =
          http.Response(fixtures.autocompleteResponse, 200);
      print('expectedUri: $expectedUri');

      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenAnswer((realInvocation) async => expectedLocation);
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockAuthenticationDataSource.getUserId()).thenReturn('someUserId');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => expectedHttpResponse);
      //act
      final actual = await sut.getAutocomplete(input);
      //assert
      expect(actual, expected);
    });
    test('should return empty list when status = "ZERO_RESULTS"', () async {
      //setup
      final apiZeroResults = '''
    {
      "status": "ZERO_RESULTS"
    }
    ''';
      final expected = List<Autocomplete>.empty();
      final expectedLocation = Location(lat: -19.0, lon: -45.0);
      final input = 'Some part of address';
      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/place/autocomplete/json',
          queryParameters: {
            'input': input,
            'sessiontoken': 'someUserId',
            'location': '${expectedLocation.lat},${expectedLocation.lon}',
            'key': 'theGeolocationApiKey',
            'radius': '100000',
            'language': 'pt-BR'
          });
      final expectedHttpResponse = http.Response(apiZeroResults, 200);
      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenAnswer((realInvocation) async => expectedLocation);
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockAuthenticationDataSource.getUserId()).thenReturn('someUserId');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => expectedHttpResponse);

      //act
      final actual = await sut.getAutocomplete(input);

      //assert
      expect(actual, expected);
    });
    test(
        'should throw AddressingException when status != "OK" and status != "ZERO_RESULTS" ',
        () {
      //setup

      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED,
          message: 'REQUEST_DENIED: The provided API key is invalid.');
      final expectedLocation = Location(lat: -19.0, lon: -45.0);
      final input = 'Some part of address';
      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/place/autocomplete/json',
          queryParameters: {
            'input': input,
            'sessiontoken': 'someUserId',
            'location': '${expectedLocation.lat},${expectedLocation.lon}',
            'key': 'theGeolocationApiKey',
            'radius': '100000',
            'language': 'pt-BR'
          });
      final expectedHttpResponse =
          http.Response(fixtures.googleGeocoderError, 200);
      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenAnswer((realInvocation) async => expectedLocation);
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockAuthenticationDataSource.getUserId()).thenReturn('someUserId');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => expectedHttpResponse);

      //act
      //assert
      expect(() async => await sut.getAutocomplete(input), throwsA(expected));
    });
    test('should throw AddressingException when status <> 200', () {
      //setup
      final apiRequestDenied = '''
    {
      "status": "REQUEST_DENIED",
      "error_message": "Your request was denied"
    }
    ''';
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Server response: 500');
      final expectedLocation = Location(lat: -19.0, lon: -45.0);
      final input = 'Some part of address';
      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/place/autocomplete/json',
          queryParameters: {
            'input': input,
            'sessiontoken': 'someUserId',
            'location': '${expectedLocation.lat},${expectedLocation.lon}',
            'key': 'theGeolocationApiKey',
            'radius': '100000',
            'language': 'pt-BR'
          });
      final expectedHttpResponse = http.Response(apiRequestDenied, 500);
      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenAnswer((realInvocation) async => expectedLocation);
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockAuthenticationDataSource.getUserId()).thenReturn('someUserId');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => expectedHttpResponse);

      //act
      //assert
      expect(() async => await sut.getAutocomplete(input), throwsA(expected));
    });
    test('should throw AddressingException when some exception is thrown', () {
      //setup
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Exception: Some error');
      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenThrow(Exception('Some error'));

      //act
      //assert
      expect(() async => await sut.getAutocomplete("Rua Novo Horizonte"),
          throwsA(expected));
    });
  });
  group('getAddressFromLocation', () {
    test('should bring the address ', () async {
      //setup
      final location = Location(lat: 10.0, lon: 10.0);
      final serviceReturns = http.Response(fixtures.googleReturnAddress, 200);
      final expected = Address(
          rawAddress:
              "Av. Epitácio Pessoa, 2566 - Ipanema, Rio de Janeiro - RJ, 22471-003, Brasil",
          street: "Avenida Epitácio Pessoa",
          number: "2566",
          complement: '',
          poCode: "22471-003",
          county: "Ipanema",
          country: Country(name: "Brasil"),
          state: State(name: "Rio de Janeiro", acronym: "RJ"),
          city: City(name: "Rio de Janeiro"),
          location: Location(lat: -22.9749636, lon: -43.1984787));

      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/geocode/json',
          queryParameters: {
            'latlng': '${location.lat},${location.lon}',
            'key': 'theGeolocationApiKey',
            'language': 'pt-BR',
            'location_type': 'ROOFTOP',
            'result_type': 'street_address',
          });
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => serviceReturns);
      //act
      final actual = await sut.getAddressFromLocation(location);
      //assert
      expect(actual, equals(expected));
    });
    test(
        'should return AddressingException when status is neither OK not ZERO_RESULTS',
        () async {
      //setup
      final location = Location(lat: 10.0, lon: 10.0);
      final serviceReturns = http.Response(fixtures.googleGeocoderError, 200);
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED,
          message: 'REQUEST_DENIED: The provided API key is invalid.');
      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/geocode/json',
          queryParameters: {
            'latlng': '${location.lat},${location.lon}',
            'key': 'theGeolocationApiKey',
            'language': 'pt-BR',
            'location_type': 'ROOFTOP',
            'result_type': 'street_address'
          });
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => serviceReturns);
      //act
      expect(() async => await sut.getAddressFromLocation(location),
          throwsA(expected));
    });

    test('should throw AddressingException when status <> 200', () {
//setup
      final location = Location(lat: 10.0, lon: 10.0);
      final serviceReturns = http.Response(fixtures.googleGeocoderError, 500);
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Status: 500');
      final expectedUri = Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          port: 443,
          path: 'maps/api/geocode/json',
          queryParameters: {
            'latlng': '${location.lat},${location.lon}',
            'key': 'theGeolocationApiKey',
            'language': 'pt-BR',
            'location_type': 'ROOFTOP',
            'result_type': 'street_address'
          });
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockHttpClient.get(expectedUri))
          .thenAnswer((realInvocation) async => serviceReturns);
      //act
      expect(() async => await sut.getAddressFromLocation(location),
          throwsA(expected));
    });

    test('should throw AddressingException when an exception occurs', () {
      //setup
      final location = Location(lat: 10.0, lon: 10.0);
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
      when(mockSecretsService.getSecret('GEOLOCATION_API_KEY'))
          .thenThrow(Exception('some error'));
      //act
      expect(() async => await sut.getAddressFromLocation(location),
          throwsA(expected));
    });
  });
}
