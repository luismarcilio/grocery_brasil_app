import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:http/http.dart' as http;

import '../domain/Product.dart';
import 'apiConfiguration.dart' as apiConfiguration;

Future<String> getThumbnailUrl(dynamic product) async {
  if (product['eanCode'] == '') {
    return '';
  }
  final snapshot = await FirebaseFirestore.instance
      .collection('PRODUTOS')
      .doc(product['eanCode'])
      .get();

  if (!snapshot.exists) {
    return '';
  }
  final productData = snapshot.data();
  if (!productData['thumbnail'].toString().contains('storage.googleapis.com')) {
    return '';
  }
  final thumbnailUrl = productData['thumbnail'];
  return thumbnailUrl;
}

Future<List<Product>> getAutocompleteTips(String root) async {
  final jwt = await FirebaseAuth.instance.currentUser.getIdToken(true);
  await apiConfiguration.initializeApiConfiguration();
  final Uri uri = Uri(
      scheme: apiConfiguration.scheme,
      host: apiConfiguration.host,
      port: apiConfiguration.port,
      path: '${apiConfiguration.path}/autocomplete/$root');
  print("uri: $uri");
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.authorizationHeader: 'Bearer $jwt',
    "Content-Type": "application/json"
  });

  print("response: " + response.statusCode.toString());

  List responseMap = jsonDecode(response.body);
  List<Product> returnList =
      responseMap.map((json) => Product.fromJson(json)).toList();
  return returnList;
}

// Future<List<Product>> getProductByNf(String nfAccessKey) async{
//   final DocumentReference docReference = await FirebaseFirestore.instance
//       .collection('COMPRAS')
//       .doc(FirebaseAuth.instance.currentUser.uid)
//       .collection('COMPLETA')
//       .doc(nfAccessKey);

//   return docReference.get()
// }
