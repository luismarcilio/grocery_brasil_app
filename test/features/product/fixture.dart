import 'package:grocery_brasil_app/domain/Unity.dart';
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
