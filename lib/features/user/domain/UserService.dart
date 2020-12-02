import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/User.dart';

abstract class UserService {
  Future<Either<UserFailure, User>> createUser(User user);
  Future<Either<UserFailure, User>> getUser();
  Future<Either<UserFailure, User>> updateUser(User user);
}
