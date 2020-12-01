const googleReturnAddress = '''
{
   "results" : [
      {
         "address_components" : [
            {
               "long_name" : "2566",
               "short_name" : "2566",
               "types" : [ "street_number" ]
            },
            {
               "long_name" : "Avenida Epitácio Pessoa",
               "short_name" : "Av. Epitácio Pessoa",
               "types" : [ "route" ]
            },
            {
               "long_name" : "Ipanema",
               "short_name" : "Ipanema",
               "types" : [ "political", "sublocality", "sublocality_level_1" ]
            },
            {
               "long_name" : "Rio de Janeiro",
               "short_name" : "Rio de Janeiro",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "Rio de Janeiro",
               "short_name" : "RJ",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "Brasil",
               "short_name" : "BR",
               "types" : [ "country", "political" ]
            },
            {
               "long_name" : "22471-003",
               "short_name" : "22471-003",
               "types" : [ "postal_code" ]
            }
         ],
         "formatted_address" : "Av. Epitácio Pessoa, 2566 - Ipanema, Rio de Janeiro - RJ, 22471-003, Brasil",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : -22.9747089,
                  "lng" : -43.1975541
               },
               "southwest" : {
                  "lat" : -22.9752519,
                  "lng" : -43.1989201
               }
            },
            "location" : {
               "lat" : -22.9749636,
               "lng" : -43.1984787
            },
            "location_type" : "GEOMETRIC_CENTER",
            "viewport" : {
               "northeast" : {
                  "lat" : -22.9736314197085,
                  "lng" : -43.1968881197085
               },
               "southwest" : {
                  "lat" : -22.9763293802915,
                  "lng" : -43.1995860802915
               }
            }
         },
         "place_id" : "ChIJMWeBRmvVmwARA6IdUQi5Nb0",
         "types" : [ "premise" ]
      }
   ],
   "status" : "OK"
}
''';

const googleGeocoderZeroResults = '''
{
   "results" : [],
   "status" : "ZERO_RESULTS"
}
''';

const googleGeocoderError = '''
{
   "error_message" : "The provided API key is invalid.",
   "results" : [],
   "status" : "REQUEST_DENIED"
}
''';

const autocompleteResponse = '''
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

const placeIdResponse = '''
{
   "results" : [
      {
         "address_components" : [
            {
               "long_name" : "Avenida Epitácio Pessoa",
               "short_name" : "Av. Epitácio Pessoa",
               "types" : [ "route" ]
            },
            {
               "long_name" : "Lagoa",
               "short_name" : "Lagoa",
               "types" : [ "political", "sublocality", "sublocality_level_1" ]
            },
            {
               "long_name" : "Rio de Janeiro",
               "short_name" : "Rio de Janeiro",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "Rio de Janeiro",
               "short_name" : "RJ",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "Brasil",
               "short_name" : "BR",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "Av. Epitácio Pessoa - Lagoa, Rio de Janeiro - RJ, Brasil",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : -22.96253699999997,
                  "lng" : -43.1976014
               },
               "southwest" : {
                  "lat" : -22.98053360000003,
                  "lng" : -43.2137415
               }
            },
            "location" : {
               "lat" : -22.9708637,
               "lng" : -43.2069645
            },
            "location_type" : "GEOMETRIC_CENTER",
            "viewport" : {
               "northeast" : {
                  "lat" : -22.96253699999997,
                  "lng" : -43.1976014
               },
               "southwest" : {
                  "lat" : -22.98053360000003,
                  "lng" : -43.2137415
               }
            }
         },
         "place_id" : "Ej1BdmVuaWRhIEVwaXTDoWNpbyBQZXNzb2EgLSBMYWdvYSwgUmlvIGRlIEphbmVpcm8gLSBSSiwgQnJhc2lsIi4qLAoUChIJea0-7gzVmwARSm9e9tHu6NESFAoSCRW9wd901ZsAEY3RX0W2bpnb",
         "types" : [ "route" ]
      }
   ],
   "status" : "OK"
}
''';
