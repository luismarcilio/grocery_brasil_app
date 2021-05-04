import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:sprintf/sprintf.dart';

import '../../../domain/User.dart';
import '../domain/LogMessage.dart';
import 'LogAdatper.dart';

class CrashlyticsLogAdapter implements LogAdapter {
  final FirebaseCrashlytics firebaseCrashlytics;

  CrashlyticsLogAdapter({@required this.firebaseCrashlytics});

  @override
  Future<void> initializeLog(User user) {
    return firebaseCrashlytics.setUserIdentifier(user.userId);
  }

  @override
  Future<void> log(LogMessage logMessage) {
    final String message = sprintf(logMessage.mask, logMessage.data);
    return firebaseCrashlytics.log(message);
  }
}
