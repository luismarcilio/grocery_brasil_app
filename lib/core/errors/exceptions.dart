import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sprintf/sprintf.dart';

enum MessageIds {
  EMAIL_NOT_VERIFIED,
  UNEXPECTED,
  NOT_LOGGED_IN,
  CANCELLED,
  NOT_FOUND,
  PERMISSION_DENIED,
  WRONG_USERNAME_OR_PASSWORD
}

class ErrorMessage {
  final MessageIds messageId;
  final String message;
  const ErrorMessage(this.messageId, this.message);
}

const emailNotVerified = ErrorMessage(MessageIds.EMAIL_NOT_VERIFIED,
    "Por favor verifique sua caixa de correio para fazer login.");

const unexpected = ErrorMessage(
    MessageIds.UNEXPECTED, "Bem... Isso é embaraçoso mas... Deu um erro aqui.");

const notLoggedIn =
    ErrorMessage(MessageIds.NOT_LOGGED_IN, "Por favor faça login");

const cancelled = ErrorMessage(MessageIds.CANCELLED, "Cancelado");

const notFound =
    ErrorMessage(MessageIds.NOT_FOUND, "Não encontrei nada por aqui");

const permissionDenied = ErrorMessage(MessageIds.PERMISSION_DENIED,
    "Desculpe. Não posso continuar se não me der permissão");

const wrongUsernameOrPasswrod = ErrorMessage(
    MessageIds.WRONG_USERNAME_OR_PASSWORD, "Usuário ou password inválidos");

final Map<MessageIds, ErrorMessage> errorMessages = {
  MessageIds.EMAIL_NOT_VERIFIED: emailNotVerified,
  MessageIds.CANCELLED: cancelled,
  MessageIds.NOT_FOUND: notFound,
  MessageIds.NOT_LOGGED_IN: notLoggedIn,
  MessageIds.PERMISSION_DENIED: permissionDenied,
  MessageIds.UNEXPECTED: unexpected,
  MessageIds.WRONG_USERNAME_OR_PASSWORD: wrongUsernameOrPasswrod
};

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

class NFReaderException extends ApplicatonException {
  NFReaderException({@required messageId, message})
      : super(messageId: messageId, message: message);
}

class FunctionsDetailsDataSourceException extends ApplicatonException {
  FunctionsDetailsDataSourceException({@required messageId, message})
      : super(messageId: messageId, message: message);
}

class PurchaseException extends ApplicatonException {
  PurchaseException({@required messageId, message})
      : super(messageId: messageId, message: message);
}

class ProductException extends ApplicatonException {
  ProductException({@required messageId, message})
      : super(messageId: messageId, message: message);
}

class UserException extends ApplicatonException {
  UserException({@required messageId, message})
      : super(messageId: messageId, message: message);
}

class AddressingException extends ApplicatonException {
  AddressingException({@required messageId, message})
      : super(messageId: messageId, message: message);
}

class SecretsException extends ApplicatonException {
  SecretsException({@required messageId, message})
      : super(messageId: messageId, message: message);
}
