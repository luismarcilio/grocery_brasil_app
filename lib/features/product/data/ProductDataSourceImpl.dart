import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../domain/Location.dart';
import '../domain/ProductPrices.dart';
import 'ProductDataSource.dart';

class ProductDataSourceImpl implements ProductDataSource {
  final FirebaseFirestore firebaseFirestore;

  ProductDataSourceImpl({@required this.firebaseFirestore});

  @override
  Future<List<ProductPrices>> listProductPricesByIdByDistanceOrderByUnitPrice(
      {Location topLeft,
      Location bottomRight,
      String productId,
      int listSize}) async {
    // final docRef =    await firebaseFirestore
    //     .collection('PRODUTOS')
    //     .doc(productId)
    //     .collection('COMPRAS')
    //     .where(field)
  }
}
