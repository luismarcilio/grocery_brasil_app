import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/User.dart';
import '../repositories/AuthenticationRepository.dart';

class AuthenticateWithGoogle implements UseCase<User, NoParams> {
  final AuthenticationRepository repository;

  AuthenticateWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.authenticateWithGoogle();
  }
}
