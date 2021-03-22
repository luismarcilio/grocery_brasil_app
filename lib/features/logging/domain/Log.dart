import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'LogMessage.dart';
import 'LogService.dart';

class Log implements UseCase<NoParams, LogMessage> {
  final LogService logService;

  Log({@required this.logService});

  @override
  Future<Either<Failure, NoParams>> call(LogMessage logMessage) async {
    try {
      await logService.log(logMessage);
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
