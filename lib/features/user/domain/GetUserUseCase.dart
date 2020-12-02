import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/User.dart';
import 'UserService.dart';

class GetUserUseCase extends UseCase<User, NoParams> {
  final UserService userService;

  GetUserUseCase({@required this.userService});

  @override
  Future<Either<UserFailure, User>> call(NoParams noParams) async {
    return userService.getUser();
  }
}
