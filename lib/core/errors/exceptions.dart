import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sprintf/sprintf.dart';

enum MessageIds { EMAIL_NOT_VERIFIED, UNEXPECTED, NOT_LOGGED_IN, CANCELLED }

class ApplicatonException extends Equatable implements Exception {
  final MessageIds messageId;
  final String message;

  get formattedMessage {
    if (message == null) {
      return messages[messageId];
    }
    return sprintf(messages[messageId], [message]);
  }

  static Map<MessageIds, String> messages = {
    MessageIds.EMAIL_NOT_VERIFIED: "Por favor verifique seu email",
    MessageIds.UNEXPECTED: "Operação falhou. (Mensagem original: [%s])"
  };

  ApplicatonException({@required this.messageId, this.message});

  @override
  List<Object> get props => [messageId, message];
}

class AuthenticationException extends ApplicatonException {
  AuthenticationException({@required messageId, message})
      : super(messageId: messageId, message: message);
}

class RegistrationException extends ApplicatonException {
  RegistrationException({@required messageId, message})
      : super(messageId: messageId, message: message);
}

class QRCodeException extends ApplicatonException {
  QRCodeException({@required messageId, message})
      : super(messageId: messageId, message: message);
}
