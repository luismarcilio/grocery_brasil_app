import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/asyncUseCase.dart';
import '../../../../domain/User.dart';
import '../service/AuthenticationService.dart';

enum AsyncLoginFailureId {
  OAUTH_FAILURE,
  GENERAL_FAILURE,
  NOT_LOGGED_IN,
  EMAIL_NOT_VERIFIED_FAILURE
}

class AsyncLoginFailure extends Failure {
  final AsyncLoginFailureId asyncLoginFailureId;
  final String message;

  AsyncLoginFailure({this.asyncLoginFailureId, this.message});

  @override
  List<Object> get props => [asyncLoginFailureId, message];
}

class AsyncLogin implements AsyncUseCase<User, NoParams> {
  final AuthenticationService authenticationService;

  AsyncLogin({@required this.authenticationService});

  @override
  Stream<Either<AsyncLoginFailure, User>> call(NoParams params) async* {
    yield* authenticationService.asyncAuthentication();
  }
}
