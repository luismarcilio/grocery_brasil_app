import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../domain/ProductPrices.dart';
import 'ProductDataSource.dart';

class ProductDataSourceImpl implements ProductDataSource {
  final FirebaseFirestore firebaseFirestore;

  ProductDataSourceImpl({@required this.firebaseFirestore});

  @override
  Stream<List<ProductPrices>> listProductPricesByIdByGeohashOrderByUnitPrice(
      {List<String> geohashList, String productId}) {
    final field = 'company.address.location.geohash.g${geohashList[0].length}';
    final docs = firebaseFirestore
        .collection('PRODUTOS')
        .doc(productId)
        .collection('COMPRAS')
        .where(field, whereIn: geohashList)
        .orderBy('unityValue')
        .snapshots()
        .asyncMap((snapshot) => snapshot.docs
            .map((doc) => ProductPrices.fromJson(doc.data()))
            .toList());
    return docs;
  }
}
