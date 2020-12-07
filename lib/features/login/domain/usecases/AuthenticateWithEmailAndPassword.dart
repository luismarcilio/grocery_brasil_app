import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/User.dart';
import '../service/AuthenticationService.dart';

class AuthenticateWithEmailAndPassword implements UseCase<User, Params> {
  final AuthenticationService authenticationService;

  AuthenticateWithEmailAndPassword({@required this.authenticationService});

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await authenticationService.authenticateWithEmailAndPassword(
        params.email, params.password);
  }
}

class Params extends Equatable {
  final String email;
  final String password;

  Params(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
