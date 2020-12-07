import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../usecases/AsyncLogin.dart';

abstract class AuthenticationService {
  Future<Either<AuthenticationFailure, String>> getUserId();
  Future<Either<AuthenticationFailure, User>> authenticateWithGoogle();
  Future<Either<AuthenticationFailure, User>> authenticateWithFacebook();
  Future<Either<AuthenticationFailure, User>> authenticateWithEmailAndPassword(
      String email, String password);
  Future<Either<AuthenticationFailure, String>> getJWT();
  Future<Either<AuthenticationFailure, bool>> logout();
  Stream<Either<AsyncLoginFailure, User>> asyncAuthentication();
}
