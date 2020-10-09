part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithUsernameAndPasswordEvent extends LoginEvent {
  final String email;
  final String password;

  LoginWithUsernameAndPasswordEvent(
      {@required this.email, @required this.password})
      : assert(email != null && password != null);

  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithFacebookEvent extends LoginEvent {}

class LogoutEvent extends LoginEvent {}

class AsyncLoginEvent extends LoginEvent {
  final Either<AsyncLoginFailure, User> event;
  AsyncLoginEvent(this.event);
}
