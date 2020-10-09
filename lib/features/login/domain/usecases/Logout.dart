import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/AuthenticationRepository.dart';

class Logout implements UseCase<bool, NoParams> {
  final AuthenticationRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.logout();
  }
}
