import 'package:equatable/equatable.dart';

class LogMessage extends Equatable {
  final Level level;
  final String mask;
  final List<dynamic> data;

  LogMessage(this.level, this.mask, this.data);

  @override
  List<Object> get props => [level, mask, data];
}

enum Level { DEBUG, INFO, WARN, ERROR, FATAL }
