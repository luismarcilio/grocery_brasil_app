import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/logging/domain/LogMessage.dart';

abstract class LogService {
  Future<void> log(LogMessage logMessage);
  Future<void> initializeLog(User user);
}
