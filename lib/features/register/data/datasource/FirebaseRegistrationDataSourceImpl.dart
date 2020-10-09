import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, UserCredential;
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/register/data/datasource/RegistrationDataSource.dart';

class FirebaseRegistrationDataSourceImpl extends RegistrationDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseRegistrationDataSourceImpl({this.firebaseAuth});

  @override
  Future<User> registerWithEmailAndPassword(
      {String email, String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user.sendEmailVerification();
      final User user = User(
          email: userCredential.user.email,
          userId: userCredential.user.uid,
          emailVerified: userCredential.user.emailVerified);
      return user;
    } catch (e) {
      throw RegistrationException(
          messageId: MessageIds.UNEXPECTED,
          message: 'Operação falhou. (Mensagem original: [${e.toString()}])');
    }
  }
}
