import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/User.dart';
import '../service/AuthenticationService.dart';

class AuthenticateWithFacebook implements UseCase<User, NoParams> {
  final AuthenticationService authenticationService;

  AuthenticateWithFacebook({@required this.authenticationService});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authenticationService.authenticateWithFacebook();
  }
}
