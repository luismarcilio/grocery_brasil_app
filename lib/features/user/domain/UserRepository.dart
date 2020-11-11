import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/User.dart';

abstract class UserRepository {
  Future<Either<UserFailure, User>> getUserByUserId(String userId);
  Future<Either<UserFailure, User>> createUser(User user);
}
