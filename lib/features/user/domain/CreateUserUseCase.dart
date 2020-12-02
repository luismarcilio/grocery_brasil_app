import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/User.dart';
import 'UserService.dart';

class CreateUserUseCase extends UseCase<User, User> {
  final UserService userService;

  CreateUserUseCase(this.userService);

  @override
  Future<Either<UserFailure, User>> call(User user) async {
    return userService.createUser(user);
  }
}
