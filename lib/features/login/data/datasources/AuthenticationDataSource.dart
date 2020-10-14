import '../../../../domain/User.dart';

abstract class AuthenticationDataSource {
  Future<User> authenticateWithGoogle();
  Future<User> authenticateWithFacebook();
  Future<User> authenticateWithEmailAndPassword(String email, String password);
  Future<void> logout();
  Future<String> getJWT();
  Stream<User> asyncAuthentication();
  String getUserId();
}
