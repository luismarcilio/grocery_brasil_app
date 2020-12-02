import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/User.dart';
import '../../login/domain/repositories/AuthenticationRepository.dart';
import 'UserRepository.dart';
import 'UserService.dart';

class UserServiceImpl implements UserService {
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;

  UserServiceImpl(
      {@required this.userRepository, @required this.authenticationRepository});

  @override
  Future<Either<UserFailure, User>> createUser(User user) async {
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

  @override
  Future<Either<UserFailure, User>> getUser() async {
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

  @override
  Future<Either<UserFailure, User>> updateUser(User user) async {
    try {
      final result = await this.userRepository.updateUser(user);
      return result;
    } catch (e) {
      return Left(
          UserFailure(messageId: MessageIds.UNEXPECTED, message: e.toString()));
    }
  }
}
