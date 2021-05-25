import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../../domain/repositories/AuthenticationRepository.dart';
import '../../domain/usecases/AsyncLogin.dart';
import '../datasources/AuthenticationDataSource.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationDataSource authenticationDataSource;

  AuthenticationRepositoryImpl({@required this.authenticationDataSource});

  @override
  Future<Either<AuthenticationFailure, User>> authenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      final User user = await this
          .authenticationDataSource
          .authenticateWithEmailAndPassword(email, password);
      return Right(user);
    } on AuthenticationException catch (authenticationException) {
      print("messageId: ${authenticationException.messageId}");
      print("message: ${authenticationException.formattedMessage}");
      return Left(
        AuthenticationFailure(
            messageId: authenticationException.messageId,
            message: authenticationException.formattedMessage),
      );
    }
  }

  @override
  Future<Either<AuthenticationFailure, User>> authenticateWithFacebook() async {
    try {
      final User user =
          await this.authenticationDataSource.authenticateWithFacebook();
      return Right(user);
    } on AuthenticationException catch (authenticationException) {
      return Left(
        AuthenticationFailure(
            messageId: authenticationException.messageId,
            message: authenticationException.formattedMessage),
      );
    }
  }

  @override
  Future<Either<AuthenticationFailure, User>> authenticateWithGoogle() async {
    try {
      final User user =
          await this.authenticationDataSource.authenticateWithGoogle();
      return Right(user);
    } on AuthenticationException catch (authenticationException) {
      return Left(
        AuthenticationFailure(
            messageId: authenticationException.messageId,
            message: authenticationException.formattedMessage),
      );
    }
  }

  @override
  Future<Either<AuthenticationFailure, String>> getJWT() async {
    try {
      return Right(await authenticationDataSource.getJWT());
    } on AuthenticationException catch (authenticationException) {
      return Left(AuthenticationFailure(
          messageId: authenticationException.messageId,
          message: authenticationException.formattedMessage));
    }
  }

  @override
  Future<Either<AuthenticationFailure, bool>> logout() async {
    try {
      await this.authenticationDataSource.logout();
      return Right(true);
    } on AuthenticationException catch (authenticationException) {
      return Left(
        AuthenticationFailure(
            messageId: authenticationException.messageId,
            message: authenticationException.formattedMessage),
      );
    }
  }

  @override
  Stream<Either<AsyncLoginFailure, User>> asyncAuthentication() async* {
    yield* authenticationDataSource.asyncAuthentication().asyncMap((user) {
      if (user == null) {
        print("return NOT_LOGGED_IN;");
        return Left(
          AsyncLoginFailure(
              asyncLoginFailureId: AsyncLoginFailureId.NOT_LOGGED_IN),
        );
      } else if (!user.emailVerified) {
        print("return EMAIL_NOT_VERIFIED_FAILURE;");
        return Left(
          AsyncLoginFailure(
              asyncLoginFailureId:
                  AsyncLoginFailureId.EMAIL_NOT_VERIFIED_FAILURE,
              message: "Por favor verifique seu email"),
        );
      }
      print("return Right(user);");
      return Right(user);
    });
  }

  @override
  Future<Either<AuthenticationFailure, String>> getUserId() {
    try {
      final userId = this.authenticationDataSource.getUserId();
      return Future.value(Right(userId));
    } on AuthenticationException catch (authenticationException) {
      return Future.value(
        Left(
          AuthenticationFailure(
              messageId: authenticationException.messageId,
              message: authenticationException.formattedMessage),
        ),
      );
    }
  }

  @override
  Future<Either<AuthenticationFailure, User>> resetPassword(
      String email) async {
    try {
      await authenticationDataSource.resetPasswrod(email);
      return Right(null);
    } catch (e) {
      return Future.value(
        Left(
          AuthenticationFailure(
              messageId: MessageIds.UNEXPECTED, message: e.toString()),
        ),
      );
    }
  }

  @override
  Future<Either<AuthenticationFailure, User>> authenticateWithApple() async {
    try {
      final User user =
          await this.authenticationDataSource.authenticateWithApple();
      return Right(user);
    } on AuthenticationException catch (authenticationException) {
      return Left(
        AuthenticationFailure(
            messageId: authenticationException.messageId,
            message: authenticationException.formattedMessage),
      );
    }
  }
}
