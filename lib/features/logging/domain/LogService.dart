import 'package:meta/meta.dart';

import '../../../domain/User.dart';
import '../data/LogAdatper.dart';
import 'LogMessage.dart';

abstract class LogService {
  Future<void> log(LogMessage logMessage);
  Future<void> initializeLog(User user);
}

class LogServiceImpl implements LogService {
  final LogAdapter logAdapter;

  LogServiceImpl({@required this.logAdapter});

  @override
  Future<void> initializeLog(User user) {
    return logAdapter.initializeLog(user);
  }

  @override
  Future<void> log(LogMessage logMessage) {
    return logAdapter.log(logMessage);
  }
}
