import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../usecases/AsyncLogin.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, String>> getUserId();
  Future<Either<Failure, User>> authenticateWithGoogle();
  Future<Either<Failure, User>> authenticateWithFacebook();
  Future<Either<Failure, User>> authenticateWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, String>> getJWT();
  Future<Either<Failure, bool>> logout();
  Stream<Either<AsyncLoginFailure, User>> asyncAuthentication();
}
