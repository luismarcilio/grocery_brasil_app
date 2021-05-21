import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/AuthenticationRepository.dart';

class ResetPassword implements UseCase<void, Params> {
  final AuthenticationRepository authenticationRepository;

  ResetPassword({@required this.authenticationRepository});

  @override
  Future<Either<Failure, void>> call(Params params) {
    return authenticationRepository.resetPassword(params.email);
  }
}

class Params extends Equatable {
  final String email;

  Params(this.email);

  @override
  List<Object> get props => [email];
}
