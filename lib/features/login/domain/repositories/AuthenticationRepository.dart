import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/features/login/domain/usecases/AsyncLogin.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> authenticateWithGoogle();
  Future<Either<Failure, User>> authenticateWithFacebook();
  Future<Either<Failure, User>> authenticateWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, String>> getJWT();
  Future<Either<Failure, bool>> logout();
  Stream<Either<AsyncLoginFailure, User>> asyncAuthentication();
}
