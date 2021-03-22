import '../../../domain/User.dart';
import '../domain/LogMessage.dart';

abstract class LogAdapter {
  Future<void> log(LogMessage logMessage);
  Future<void> initializeLog(User user);
}
