import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/User.dart';

abstract class UserService {
  Future<Either<UserFailure, User>> createUser(User user);
  Future<Either<UserFailure, User>> getUser();
  Future<Either<UserFailure, User>> updateUser(User user);
}
