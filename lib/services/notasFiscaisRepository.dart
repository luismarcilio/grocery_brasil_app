import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Stream<dynamic> getResumeNfForUser() {
  final String userId =
      'RESUMOS-USERID:${FirebaseAuth.instance.currentUser.uid}';
  final CollectionReference resumeNfStream =
      FirebaseFirestore.instance.collection(userId);
  return resumeNfStream.orderBy('date', descending: true).snapshots();
}

Future<DocumentSnapshot> getFullNfFromDocId(String docId) async {
  final String userId = 'USERID:${FirebaseAuth.instance.currentUser.uid}';
  final DocumentReference docReference =
      FirebaseFirestore.instance.collection(userId).doc(docId);
  final DocumentSnapshot doc = await docReference.get();
  return doc;
}
