import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

import '../domain/Address.dart';
import '../domain/User.dart';

class UserNotFoundException {}

class UserRepository {
  Future<User> updateUser(User user) async {
    print("updateUser: ${user.address}");
    await FirebaseFirestore.instance
        .collection('USUARIOS')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(user.toJson());
    return user;
  }

  Future<void> saveUserAddress(Address address) async {
    print('saveUserAddress($address)');
    final DocumentReference userDoc = FirebaseFirestore.instance
        .collection('USUARIOS')
        .doc(FirebaseAuth.instance.currentUser.uid);

    final User user = User(
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

  Future<User> getUserByUserId(String userId) async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('USUARIOS')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (!userDoc.exists) {
      throw UserNotFoundException;
    }

    return User.fromJson(userDoc.data());
  }
}
