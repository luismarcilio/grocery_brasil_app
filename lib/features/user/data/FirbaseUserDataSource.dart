import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/User.dart';
import 'UserDataSource.dart';

class FirbaseUserDataSource extends UserDataSource {
  final FirebaseFirestore firebaseFirestore;

  FirbaseUserDataSource({@required this.firebaseFirestore});

  @override
  Future<User> createUser(User user) async {
    print('user : $user');
    try {
      await firebaseFirestore
          .collection('USUARIOS')
          .doc(user.userId)
          .set(user.toJson());
      return user;
    } catch (e) {
      throw UserException(
        messageId: MessageIds.UNEXPECTED,
        message: e.toString(),
      );
    }
  }

  @override
  Future<User> getUserByUserId(String userId) async {
    try {
      final doc =
          await firebaseFirestore.collection('USUARIOS').doc(userId).get();
      if (!doc.exists) {
        throw UserException(
            messageId: MessageIds.NOT_FOUND, message: 'User $userId not found');
      }

      return User.fromJson(doc.data());
    } catch (e) {
      if (e is UserException) {
        throw e;
      }
      throw UserException(
        messageId: MessageIds.UNEXPECTED,
        message: e.toString(),
      );
    }
  }

  @override
  Future<User> updateUser(User user) {
    return createUser(user);
  }
}
