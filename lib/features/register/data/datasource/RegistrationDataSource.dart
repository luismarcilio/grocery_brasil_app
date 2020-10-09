import '../../../../domain/User.dart';

abstract class RegistrationDataSource {
  Future<User> registerWithEmailAndPassword({String email, String password});
}
