import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/Company.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/domain/Product.dart';
import 'package:grocery_brasil_app/domain/Unity.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/domain/UserPreferences.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductPrices.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductSearchModel.dart';

const returnFromElasticSearch = '''
{
  "took" : 302,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 4,
      "relation" : "eq"
    },
    "max_score" : 2.7084918,
    "hits" : [
      {
        "_index" : "produtos_autocomplete",
        "_type" : "_doc",
        "_id" : "7898994095156",
        "_score" : 2.7084918,
        "_source" : {
          "eanCode" : "7898994095156",
          "name" : "LEITE LACTUS INTEGRAL",
          "ncmCode" : "4012010",
          "normalized" : true,
          "thumbnail" : "https://storage.googleapis.com/grocery-brasil-app-thumbnails/7898994095156",
          "unity" : {
            "name" : "UN"
          }
        }
      },
      {
        "_index" : "produtos_autocomplete",
        "_type" : "_doc",
        "_id" : "7896286604154",
        "_score" : 2.0831158,
        "_source" : {
          "eanCode" : "7896286604154",
          "name" : "BISCOITO CORY PALITO CHOCOLATE AO LEITE",
          "firebaseDocId" : "7896286604154",
          "thumbnail" : "https://storage.googleapis.com/grocery-brasil-app-thumbnails/7896286604154"
        }
      },
      {
        "_index" : "produtos_autocomplete",
        "_type" : "_doc",
        "_id" : "7622300991500",
        "_score" : 1.8052361,
        "_source" : {
          "eanCode" : "7622300991500",
          "name" : "CHOCOLATE AO LEITE LACTA DIAMANTE NEGRO PACOTE 90G",
          "firebaseDocId" : "7622300991500",
          "thumbnail" : "https://storage.googleapis.com/grocery-brasil-app-thumbnails/7622300991500"
        }
      },
      {
        "_index" : "produtos_autocomplete",
        "_type" : "_doc",
        "_id" : "7891025105244",
        "_score" : 1.2892814,
        "_source" : {
          "eanCode" : "7891025105244",
          "name" : "PACK SOBREMESA LÁCTEA CHOCOLATE AO LEITE DANETTE BANDEJA 720G 8 UNIDADES GRÁTIS 1 UNIDADE",
          "firebaseDocId" : "7891025105244",
          "thumbnail" : "https://storage.googleapis.com/grocery-brasil-app-thumbnails/7891025105244"
        }
      }
    ]
  }
}
''';

final expected = [
  ProductSearchModel(
      eanCode: '7898994095156',
      name: 'LEITE LACTUS INTEGRAL',
      ncmCode: '4012010',
      normalized: true,
      thumbnail:
          'https://storage.googleapis.com/grocery-brasil-app-thumbnails/7898994095156',
      unity: Unity(name: 'UN')),
  ProductSearchModel(
      eanCode: '7896286604154',
      name: 'BISCOITO CORY PALITO CHOCOLATE AO LEITE',
      ncmCode: null,
      normalized: null,
      thumbnail:
          'https://storage.googleapis.com/grocery-brasil-app-thumbnails/7896286604154',
      unity: null),
  ProductSearchModel(
      eanCode: '7622300991500',
      name: 'CHOCOLATE AO LEITE LACTA DIAMANTE NEGRO PACOTE 90G',
      ncmCode: null,
      normalized: null,
      thumbnail:
          'https://storage.googleapis.com/grocery-brasil-app-thumbnails/7622300991500',
      unity: null),
  ProductSearchModel(
      eanCode: '7891025105244',
      name:
          'PACK SOBREMESA LÁCTEA CHOCOLATE AO LEITE DANETTE BANDEJA 720G 8 UNIDADES GRÁTIS 1 UNIDADE',
      ncmCode: null,
      normalized: null,
      thumbnail:
          'https://storage.googleapis.com/grocery-brasil-app-thumbnails/7891025105244',
      unity: null),
];

const failFromElasticSearch = '''
{
  "error" : {
    "root_cause" : [
      {
        "type" : "index_not_found_exception",
        "reason" : "no such index [produtos_autocomplet]",
        "resource.type" : "index_or_alias",
        "resource.id" : "produtos_autocomplet",
        "index_uuid" : "_na_",
        "index" : "produtos_autocomplet"
      }
    ],
    "type" : "index_not_found_exception",
    "reason" : "no such index [produtos_autocomplet]",
    "resource.type" : "index_or_alias",
    "resource.id" : "produtos_autocomplet",
    "index_uuid" : "_na_",
    "index" : "produtos_autocomplet"
  },
  "status" : 404
}

''';

final oneProductPrice = ProductPrices(
    product: Product(
        name: 'DETERGENTE LÍQUIDO CLEAR YPÊ FRASCO 500ML',
        eanCode: "7896098900253",
        ncmCode: '34022000',
        unity: Unity(name: 'UN'),
        normalized: true,
        thumbnail:
            'https://storage.googleapis.com/grocery-brasil-app-thumbnails/7896098900253'),
    company: Company(
        name: 'ZEBU CARNES SUPERMERCADOS LTDA',
        taxIdentification: '03.214.362/0003-35',
        address: Address(
            rawAddress:
                'Av. da Saudade, 1110 - Santa Marta, Uberaba - MG, 38061-000, Brasil',
            street: 'Avenida da Saudade',
            number: '1110',
            complement: '',
            poCode: '38061-000',
            county: 'Santa Marta',
            country: Country(name: 'Brasil'),
            state: State(acronym: 'MG', name: 'Minas Gerais'),
            city: City(name: 'Uberaba'),
            location: Location(lon: -47.9562274, lat: -19.7433014))),
    unityValue: 15.0,
    purchaseDate: DateTime.now());

final oneUser = User(
    preferences: UserPreferences(searchRadius: 100000),
    email: 'someEmail',
    address: Address(
        rawAddress:
            'Av. Epitácio Pessoa, 2566 - Lagoa, Rio de Janeiro - RJ, 22471-003, Brasil',
        street: 'Epitácio Pessoa',
        number: '2566',
        complement: '',
        poCode: '22471-003',
        county: 'Lagoa',
        country: Country(name: 'Brasil'),
        state: State(acronym: 'RJ', name: 'Rio de Janeiro'),
        city: City(name: 'RJ'),
        location: Location(lon: -43.199457, lat: -22.9745891)),
    userId: 'wMXsa4sYvUPBZAi1UFqMxNsLjI02',
    emailVerified: true);
