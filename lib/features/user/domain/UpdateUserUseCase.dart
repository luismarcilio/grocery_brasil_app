import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/User.dart';
import 'UserService.dart';

class UpdateUserUseCase extends UseCase<User, User> {
  final UserService userService;

  UpdateUserUseCase(this.userService);

  @override
  Future<Either<UserFailure, User>> call(User user) async {
    return userService.updateUser(user);
  }
}
