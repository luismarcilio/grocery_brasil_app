import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_brasil_app/model/Model.dart' as BusinessModel;

Future<void> saveUserAddress(BusinessModel.Address address) async {
  print('saveUserAddress($address)');
  final DocumentReference userDoc = FirebaseFirestore.instance
      .collection('USUARIOS')
      .doc(FirebaseAuth.instance.currentUser.uid);

  final BusinessModel.User user = BusinessModel.User(
      address: address,
      email: FirebaseAuth.instance.currentUser.email,
      userId: FirebaseAuth.instance.currentUser.uid);
  print('user = $user');
  print('user.toJson = ${user.toJson()}');
  DocumentSnapshot doc = await userDoc.get();
  if (doc.exists) {
    await userDoc.update(user.toJson());
  } else {
    await userDoc.set(user.toJson());
  }
}
