import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../domain/Purchase.dart';

abstract class PurchaseRepository {
  Stream<List<Purchase>> getResumePurchaseForUser(String userId);
  Future<Purchase> getPurchaseFromDocId(String docId);
}

@immutable
class PurchaseNotFoundExcepption {
  final String _docId;

  PurchaseNotFoundExcepption(this._docId);
}

class FirestorePurchaseRepository extends PurchaseRepository {
  @override
  Stream<List<Purchase>> getResumePurchaseForUser(String userId) {
    final CollectionReference resumeNfStream = FirebaseFirestore.instance
        .collection('COMPRAS')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('RESUMIDA');
    return resumeNfStream
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Purchase.fromResumeSnapshot(doc))
          .toList();
    });
  }

  @override
  Future<Purchase> getPurchaseFromDocId(String docId) async {
    final DocumentReference docReference = FirebaseFirestore.instance
        .collection('COMPRAS')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('COMPLETA')
        .doc(docId);
    final DocumentSnapshot doc = await docReference.get();
    if (!doc.exists) {
      throw PurchaseNotFoundExcepption(docId);
    }

    final Purchase purchase = Purchase.fromJson(doc.data());
    return purchase;
  }
}
