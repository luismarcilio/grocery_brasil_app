import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/User.dart';
import '../repositories/AuthenticationRepository.dart';

class AuthenticateWithEmailAndPassword implements UseCase<User, Params> {
  final AuthenticationRepository repository;

  AuthenticateWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await repository.authenticateWithEmailAndPassword(
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
