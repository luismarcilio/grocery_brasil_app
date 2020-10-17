import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/Purchase.dart';

abstract class PurchaseDataSource {
  Stream<List<Purchase>> listPurchaseResume({@required String userId});
  Future<Purchase> getPurchaseById(
      {@required String purchaseId, @required String userId});
}

class PurchaseDataSourceImpl extends PurchaseDataSource {
  final FirebaseFirestore firebaseFirestore;

  PurchaseDataSourceImpl({@required this.firebaseFirestore});

  @override
  Stream<List<Purchase>> listPurchaseResume({@required String userId}) {
    final CollectionReference resumeNfStream = firebaseFirestore
        .collection('COMPRAS')
        .doc(userId)
        .collection('RESUMIDA');

    final streamPurchase = resumeNfStream
        .orderBy('date', descending: true)
        .snapshots()
        .asyncMap((snapshot) {
      final purchaseList =
          snapshot.docs.map((doc) => Purchase.fromResumeSnapshot(doc)).toList();
      return purchaseList;
    });
    return streamPurchase;
  }

  @override
  Future<Purchase> getPurchaseById(
      {@required String purchaseId, @required String userId}) async {
    final documentSnapshot = await firebaseFirestore
        .collection('COMPRAS')
        .doc(userId)
        .collection('COMPLETA')
        .doc(purchaseId)
        .get();

    if (!documentSnapshot.exists) {
      throw PurchaseException(messageId: MessageIds.NOT_FOUND);
    }
    return Purchase.fromJson(documentSnapshot.data());
  }
}
