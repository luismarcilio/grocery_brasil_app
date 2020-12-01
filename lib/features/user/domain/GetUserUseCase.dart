import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/User.dart';
import '../../login/domain/repositories/AuthenticationRepository.dart';
import 'UserRepository.dart';

class GetUserUseCase extends UseCase<User, NoParams> {
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;

  GetUserUseCase(
      {@required this.userRepository, @required this.authenticationRepository});

  @override
  Future<Either<UserFailure, User>> call(NoParams noParams) async {
    try {
      final result = await authenticationRepository.getUserId();
      String userId;
      result.fold((l) => null, (r) => userId = r);
      final user = await this.userRepository.getUserByUserId(userId);
      return user;
    } catch (e) {
      return Left(
          UserFailure(messageId: MessageIds.UNEXPECTED, message: e.toString()));
    }
  }
}
