import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/User.dart';
import 'LogService.dart';

class InitializeLog implements UseCase<NoParams, User> {
  final LogService logService;

  InitializeLog({@required this.logService});

  @override
  Future<Either<LoggingFailure, NoParams>> call(User user) async {
    try {
      await logService.initializeLog(user);
      return Right(NoParams());
    } catch (e) {
      return Left(
        LoggingFailure(
          messageId: MessageIds.UNEXPECTED,
          message: e.toString(),
        ),
      );
    }
  }
}
