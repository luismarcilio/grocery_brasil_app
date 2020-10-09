import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  final MessageIds messageId;
  final String message;

  Failure({@required this.messageId, this.message});
  @override
  List<Object> get props => [messageId, message];
}

class AuthenticationFailure extends Failure {
  final MessageIds messageId;
  final String message;

  AuthenticationFailure({@required this.messageId, this.message});
  @override
  List<Object> get props => [messageId, message];
}

class RegistrationFailure extends Failure {
  final MessageIds messageId;
  final String message;

  RegistrationFailure({@required this.messageId, this.message});
  @override
  List<Object> get props => [messageId, message];
}

class QRCodeFailure extends Failure {
  final MessageIds messageId;
  final String message;

  QRCodeFailure({@required this.messageId, this.message});
  @override
  List<Object> get props => [messageId, message];
}

class NfHtmlFromSiteFailure extends Failure {
  NfHtmlFromSiteFailure({@required MessageIds messageId, String message})
      : super(messageId: messageId, message: message);

  @override
  List<Object> get props => [messageId, message];
}
