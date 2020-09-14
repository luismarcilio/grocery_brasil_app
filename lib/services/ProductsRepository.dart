import 'package:cloud_firestore/cloud_firestore.dart';

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
