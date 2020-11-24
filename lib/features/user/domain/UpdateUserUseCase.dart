import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/User.dart';
import 'UserRepository.dart';

class UpdateUserUseCase extends UseCase<User, User> {
  final UserRepositoryUpdate userRepository;

  UpdateUserUseCase(this.userRepository);

  @override
  Future<Either<UserFailure, User>> call(User user) async {
    try {
      final result = await this.userRepository.updateUser(user);
      return result;
    } catch (e) {
      return Left(
          UserFailure(messageId: MessageIds.UNEXPECTED, message: e.toString()));
    }
  }
}
