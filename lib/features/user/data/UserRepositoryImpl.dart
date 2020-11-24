import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/UserPreferences.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/User.dart';
import '../../addressing/data/AddressingDataSource.dart';
import '../domain/UserRepository.dart';
import 'UserDataSource.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDataSource userDataSource;
  final AddressingDataSource addressingDataSource;

  UserRepositoryImpl(
      {@required this.userDataSource, @required this.addressingDataSource});

  @override
  Future<Either<UserFailure, User>> createUser(User user) async {
    try {
      final currentAddress = await addressingDataSource.getCurrentAddress();
      User newUser = User(
          preferences: UserPreferences(searchRadius: 30000),
          email: user.email,
          address: currentAddress,
          userId: user.userId,
          emailVerified: user.emailVerified);

      print('newUser: $newUser');
      final userSaved = await userDataSource.createUser(newUser);
      return Right(userSaved);
    } catch (e) {
      if (e is UserException) {
        return Left(
          UserFailure(
            messageId: e.messageId,
            message: e.message,
          ),
        );
      }
      return Left(
        UserFailure(
          messageId: MessageIds.UNEXPECTED,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<UserFailure, User>> getUserByUserId(String userId) async {
    try {
      final user = await userDataSource.getUserByUserId(userId);
      return Right(user);
    } catch (e) {
      if (e is UserException) {
        return Left(
          UserFailure(
            messageId: e.messageId,
            message: e.message,
          ),
        );
      }
      return Left(
        UserFailure(
          messageId: MessageIds.UNEXPECTED,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<UserFailure, User>> updateUser(User user) async {
    try {
      final updatedUser = await userDataSource.updateUser(user);
      return Right(updatedUser);
    } catch (e) {
      if (e is UserException) {
        return Left(
          UserFailure(
            messageId: e.messageId,
            message: e.message,
          ),
        );
      }
      return Left(
        UserFailure(
          messageId: MessageIds.UNEXPECTED,
          message: e.toString(),
        ),
      );
    }
  }
}
