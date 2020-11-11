import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/user/domain/UserRepository.dart';

class CreateUserUseCase extends UseCase<User, User> {
  final UserRepository userRepository;

  CreateUserUseCase(this.userRepository);

  @override
  Future<Either<UserFailure, User>> call(User user) async {
    try {
      final userInRepository =
          await this.userRepository.getUserByUserId(user.userId);
      if (userInRepository.isRight()) {
        return userInRepository;
      }
      final userCreated = await this.userRepository.createUser(user);
      return userCreated;
    } catch (e) {
      return Left(
          UserFailure(messageId: MessageIds.UNEXPECTED, message: e.toString()));
    }
  }
}
