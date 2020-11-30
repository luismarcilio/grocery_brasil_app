import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/features/addressing/data/AddressAutocompleteService.dart';
import 'package:grocery_brasil_app/features/addressing/data/AddressAutocompleteServiceImpl.dart';
import 'package:grocery_brasil_app/features/addressing/data/GPSServiceAdapter.dart';
import 'package:grocery_brasil_app/features/addressing/domain/Autocomplete.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/AuthenticationDataSource.dart';
import 'package:grocery_brasil_app/features/secrets/data/SecretDataSource.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockSecretDataSource extends Mock implements SecretDataSource {}

class MockHttpClient extends Mock implements http.Client {}

class MockGPSServiceAdapter extends Mock implements GPSServiceAdapter {}

class MockAuthenticationDataSource extends Mock
    implements AuthenticationDataSource {}

const apiResult = '''
{
    "predictions": [
        {
            "description": "Rua Novo Horizonte - Montanhão, São Bernardo do Campo - SP, Brasil",
            "matched_substrings": [
                {
                    "length": 18,
                    "offset": 0
                }
            ],
            "place_id": "EkRSdWEgTm92byBIb3Jpem9udGUgLSBNb250YW5ow6NvLCBTw6NvIEJlcm5hcmRvIGRvIENhbXBvIC0gU1AsIEJyYXNpbCIuKiwKFAoSCe3CKD3wQc6UEZuecd6OoJUbEhQKEgm5Sqj450HOlBH8WjlCtuJNAA",
            "reference": "EkRSdWEgTm92byBIb3Jpem9udGUgLSBNb250YW5ow6NvLCBTw6NvIEJlcm5hcmRvIGRvIENhbXBvIC0gU1AsIEJyYXNpbCIuKiwKFAoSCe3CKD3wQc6UEZuecd6OoJUbEhQKEgm5Sqj450HOlBH8WjlCtuJNAA",
            "structured_formatting": {
                "main_text": "Rua Novo Horizonte",
                "main_text_matched_substrings": [
                    {
                        "length": 18,
                        "offset": 0
                    }
                ],
                "secondary_text": "Montanhão, São Bernardo do Campo - SP, Brasil"
            },
            "terms": [
                {
                    "offset": 0,
                    "value": "Rua Novo Horizonte"
                },
                {
                    "offset": 21,
                    "value": "Montanhão"
                },
                {
                    "offset": 32,
                    "value": "São Bernardo do Campo"
                },
                {
                    "offset": 56,
                    "value": "SP"
                },
                {
                    "offset": 60,
                    "value": "Brasil"
                }
            ],
            "types": [
                "route",
                "geocode"
            ]
        },
        {
            "description": "Rua Novo Horizonte da Sussuarana - Novo Horizonte, Salvador - BA, Brasil",
            "matched_substrings": [
                {
                    "length": 18,
                    "offset": 0
                }
            ],
            "place_id": "EkhSdWEgTm92byBIb3Jpem9udGUgZGEgU3Vzc3VhcmFuYSAtIE5vdm8gSG9yaXpvbnRlLCBTYWx2YWRvciAtIEJBLCBCcmFzaWwiLiosChQKEgkLawaEfhoWBxGP4aQzxESxUhIUChIJG3yFS34aFgcR4WTWoZzv84Y",
            "reference": "EkhSdWEgTm92byBIb3Jpem9udGUgZGEgU3Vzc3VhcmFuYSAtIE5vdm8gSG9yaXpvbnRlLCBTYWx2YWRvciAtIEJBLCBCcmFzaWwiLiosChQKEgkLawaEfhoWBxGP4aQzxESxUhIUChIJG3yFS34aFgcR4WTWoZzv84Y",
            "structured_formatting": {
                "main_text": "Rua Novo Horizonte da Sussuarana",
                "main_text_matched_substrings": [
                    {
                        "length": 18,
                        "offset": 0
                    }
                ],
                "secondary_text": "Novo Horizonte, Salvador - BA, Brasil"
            },
            "terms": [
                {
                    "offset": 0,
                    "value": "Rua Novo Horizonte da Sussuarana"
                },
                {
                    "offset": 35,
                    "value": "Novo Horizonte"
                },
                {
                    "offset": 51,
                    "value": "Salvador"
                },
                {
                    "offset": 62,
                    "value": "BA"
                },
                {
                    "offset": 66,
                    "value": "Brasil"
                }
            ],
            "types": [
                "route",
                "geocode"
            ]
        },
        {
            "description": "Rua Novo Horizonte - Higienópolis, São Paulo - SP, Brasil",
            "matched_substrings": [
                {
                    "length": 18,
                    "offset": 0
                }
            ],
            "place_id": "EjtSdWEgTm92byBIb3Jpem9udGUgLSBIaWdpZW7Ds3BvbGlzLCBTw6NvIFBhdWxvIC0gU1AsIEJyYXNpbCIuKiwKFAoSCaFPrHAuWM6UEQONrkKM0EB6EhQKEglVtfr2O1jOlBHd1UzRDYVn9A",
            "reference": "EjtSdWEgTm92byBIb3Jpem9udGUgLSBIaWdpZW7Ds3BvbGlzLCBTw6NvIFBhdWxvIC0gU1AsIEJyYXNpbCIuKiwKFAoSCaFPrHAuWM6UEQONrkKM0EB6EhQKEglVtfr2O1jOlBHd1UzRDYVn9A",
            "structured_formatting": {
                "main_text": "Rua Novo Horizonte",
                "main_text_matched_substrings": [
                    {
                        "length": 18,
                        "offset": 0
                    }
                ],
                "secondary_text": "Higienópolis, São Paulo - SP, Brasil"
            },
            "terms": [
                {
                    "offset": 0,
                    "value": "Rua Novo Horizonte"
                },
                {
                    "offset": 21,
                    "value": "Higienópolis"
                },
                {
                    "offset": 35,
                    "value": "São Paulo"
                },
                {
                    "offset": 47,
                    "value": "SP"
                },
                {
                    "offset": 51,
                    "value": "Brasil"
                }
            ],
            "types": [
                "route",
                "geocode"
            ]
        },
        {
            "description": "Rua Novo Horizonte - Jardim Ana Estela, Carapicuíba - SP, Brasil",
            "matched_substrings": [
                {
                    "length": 18,
                    "offset": 0
                }
            ],
            "place_id": "EkFSdWEgTm92byBIb3Jpem9udGUgLSBKYXJkaW0gQW5hIEVzdGVsYSwgQ2FyYXBpY3XDrWJhIC0gU1AsIEJyYXNpbCIuKiwKFAoSCQOGO7s_AM-UEb7ixU13WGoYEhQKEgk_plOEFQDPlBGG6QXM0x9eAg",
            "reference": "EkFSdWEgTm92byBIb3Jpem9udGUgLSBKYXJkaW0gQW5hIEVzdGVsYSwgQ2FyYXBpY3XDrWJhIC0gU1AsIEJyYXNpbCIuKiwKFAoSCQOGO7s_AM-UEb7ixU13WGoYEhQKEgk_plOEFQDPlBGG6QXM0x9eAg",
            "structured_formatting": {
                "main_text": "Rua Novo Horizonte",
                "main_text_matched_substrings": [
                    {
                        "length": 18,
                        "offset": 0
                    }
                ],
                "secondary_text": "Jardim Ana Estela, Carapicuíba - SP, Brasil"
            },
            "terms": [
                {
                    "offset": 0,
                    "value": "Rua Novo Horizonte"
                },
                {
                    "offset": 21,
                    "value": "Jardim Ana Estela"
                },
                {
                    "offset": 40,
                    "value": "Carapicuíba"
                },
                {
                    "offset": 54,
                    "value": "SP"
                },
                {
                    "offset": 58,
                    "value": "Brasil"
                }
            ],
            "types": [
                "route",
                "geocode"
            ]
        },
        {
            "description": "Rua Novo Horizonte - Liberdade, Parauapebas - PA, Brasil",
            "matched_substrings": [
                {
                    "length": 18,
                    "offset": 0
                }
            ],
            "place_id": "EjhSdWEgTm92byBIb3Jpem9udGUgLSBMaWJlcmRhZGUsIFBhcmF1YXBlYmFzIC0gUEEsIEJyYXNpbCIuKiwKFAoSCXF9mLjwUN2SEQCdB28TIPGDEhQKEgnDnKHp71DdkhEfZnyejX2W7w",
            "reference": "EjhSdWEgTm92byBIb3Jpem9udGUgLSBMaWJlcmRhZGUsIFBhcmF1YXBlYmFzIC0gUEEsIEJyYXNpbCIuKiwKFAoSCXF9mLjwUN2SEQCdB28TIPGDEhQKEgnDnKHp71DdkhEfZnyejX2W7w",
            "structured_formatting": {
                "main_text": "Rua Novo Horizonte",
                "main_text_matched_substrings": [
                    {
                        "length": 18,
                        "offset": 0
                    }
                ],
                "secondary_text": "Liberdade, Parauapebas - PA, Brasil"
            },
            "terms": [
                {
                    "offset": 0,
                    "value": "Rua Novo Horizonte"
                },
                {
                    "offset": 21,
                    "value": "Liberdade"
                },
                {
                    "offset": 32,
                    "value": "Parauapebas"
                },
                {
                    "offset": 46,
                    "value": "PA"
                },
                {
                    "offset": 50,
                    "value": "Brasil"
                }
            ],
            "types": [
                "route",
                "geocode"
            ]
        }
    ],
    "status": "OK"
}
''';
main() {
  MockSecretDataSource mockSecretDataSource;
  MockHttpClient mockHttpClient;
  MockGPSServiceAdapter mockGPSServiceAdapter;
  MockAuthenticationDataSource mockAuthenticationDataSource;
  AddressAutocompleteService sut;

  setUp(() {
    mockSecretDataSource = new MockSecretDataSource();
    mockHttpClient = new MockHttpClient();
    mockAuthenticationDataSource = new MockAuthenticationDataSource();
    mockGPSServiceAdapter = new MockGPSServiceAdapter();
    sut = new AddressAutocompleteServiceImpl(
        authenticationDataSource: mockAuthenticationDataSource,
        httpClient: mockHttpClient,
        secretDataSource: mockSecretDataSource,
        gPSServiceAdapter: mockGPSServiceAdapter);
  });
  group('AddressAutocompleteServiceImpl', () {
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
      final expectedHttpResponse = http.Response(apiResult, 200);
      print('expectedUri: $expectedUri');

      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenAnswer((realInvocation) async => expectedLocation);
      when(mockSecretDataSource.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockAuthenticationDataSource.getUserId()).thenReturn('someUserId');
      when(mockHttpClient.get(expectedUri.toString()))
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
      when(mockSecretDataSource.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockAuthenticationDataSource.getUserId()).thenReturn('someUserId');
      when(mockHttpClient.get(expectedUri.toString()))
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
      final apiRequestDenied = '''
    {
      "status": "REQUEST_DENIED",
      "error_message": "Your request was denied"
    }
    ''';
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED,
          message: 'REQUEST_DENIED: Your request was denied');
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
      final expectedHttpResponse = http.Response(apiRequestDenied, 200);
      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenAnswer((realInvocation) async => expectedLocation);
      when(mockSecretDataSource.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockAuthenticationDataSource.getUserId()).thenReturn('someUserId');
      when(mockHttpClient.get(expectedUri.toString()))
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
      when(mockSecretDataSource.getSecret('GEOLOCATION_API_KEY'))
          .thenAnswer((realInvocation) async => 'theGeolocationApiKey');
      when(mockAuthenticationDataSource.getUserId()).thenReturn('someUserId');
      when(mockHttpClient.get(expectedUri.toString()))
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
}
