import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../../../../domain/UserPreferences.dart';
import '../../../addressing/data/AddressingDataSource.dart';
import '../../../user/domain/UserService.dart';
import '../repositories/AuthenticationRepository.dart';
import '../usecases/AsyncLogin.dart';
import 'AuthenticationService.dart';

class AuthenticationServiceImpl implements AuthenticationService {
  final AuthenticationRepository authenticationRepository;
  final AddressingDataSource addressingDataSource;
  final UserService userService;

  AuthenticationServiceImpl(
      {@required this.authenticationRepository,
      @required this.addressingDataSource,
      @required this.userService});

  @override
  Stream<Either<AsyncLoginFailure, User>> asyncAuthentication() {
    return authenticationRepository.asyncAuthentication();
  }

  @override
  Future<Either<AuthenticationFailure, User>> authenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      final authenticationResult = await authenticationRepository
          .authenticateWithEmailAndPassword(email, password);
      return _checkUserInDb(authenticationResult);
    } on AuthenticationException catch (authenticationException) {
      return Left(AuthenticationFailure(
          messageId: authenticationException.messageId,
          message: authenticationException.message));
    } catch (e) {
      return Left(AuthenticationFailure(
          messageId: MessageIds.UNEXPECTED, message: e.toString(0)));
    }
  }

  @override
  Future<Either<AuthenticationFailure, User>> authenticateWithFacebook() {
    return _authenticationServiceOAuth(
        authenticationRepository.authenticateWithFacebook);
  }

  @override
  Future<Either<AuthenticationFailure, User>> authenticateWithGoogle() async {
    return _authenticationServiceOAuth(
        authenticationRepository.authenticateWithGoogle);
  }

  @override
  Future<Either<AuthenticationFailure, String>> getJWT() {
    return authenticationRepository.getJWT();
  }

  @override
  Future<Either<AuthenticationFailure, String>> getUserId() {
    return authenticationRepository.getUserId();
  }

  @override
  Future<Either<AuthenticationFailure, bool>> logout() {
    return authenticationRepository.logout();
  }

  Future<Either<AuthenticationFailure, User>> _authenticationServiceOAuth(
      Function authentication) async {
    try {
      final authenticationResult = await authentication();
      return _checkUserInDb(authenticationResult);
    } catch (e) {
      if (e is Failure) {
        return Left(
            AuthenticationFailure(messageId: e.messageId, message: e.message));
      }
      return Left(AuthenticationFailure(
          messageId: MessageIds.UNEXPECTED, message: e.toString()));
    }
  }

  Future<Either<AuthenticationFailure, User>> _checkUserInDb(
      Either<Failure, User> authResult) async {
    if (authResult.isLeft()) {
      return authResult;
    }
    User authenticatedUser;
    authResult.fold((l) => null, (r) => authenticatedUser = r);
    final getUserResult = await userService.getUser();
    if (getUserResult.isRight()) {
      User userInDb;
      getUserResult.fold((l) => null, (r) => userInDb = r);
      return Right(userInDb);
    }
    UserFailure userFailure;
    getUserResult.fold((l) => userFailure = l, (r) => null);
    if (userFailure.messageId == MessageIds.NOT_FOUND) {
      final currentAddress = await addressingDataSource.getCurrentAddress();
      final userInDb = User(
          email: authenticatedUser.email,
          userId: authenticatedUser.userId,
          emailVerified: authenticatedUser.emailVerified,
          address: currentAddress,
          preferences: UserPreferences(searchRadius: 30000));

      final createUser = await userService.createUser(userInDb);
      if (createUser.isRight()) {
        User userCreated;
        createUser.fold((l) => null, (r) => userCreated = r);
        return Right(userCreated);
      }
    }
    return Left(
      AuthenticationFailure(
          messageId: userFailure.messageId, message: userFailure.message),
    );
  }

  @override
  Future<Either<AuthenticationFailure, User>> authenticateWithApple() {
    return _authenticationServiceOAuth(
        authenticationRepository.authenticateWithApple);
  }
}
