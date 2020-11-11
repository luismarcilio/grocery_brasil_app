import '../../../domain/User.dart';

abstract class UserDataSource {
  Future<User> createUser(User user);
  Future<User> getUserByUserId(String userId);
}
