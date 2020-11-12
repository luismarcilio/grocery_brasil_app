part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginRunning extends LoginState {}

class LoginDone extends LoginState {
  final User user;

  LoginDone(this.user);
  @override
  List<Object> get props => [user];
}

class LoginError extends LoginState {
  final AuthenticationFailure failure;

  LoginError(this.failure);
  @override
  List<Object> get props => [failure];
}

class LogoutDone extends LoginState {}

class UserCreating extends LoginState {}

class UserCreated extends LoginState {
  final User user;

  UserCreated(this.user);
  @override
  List<Object> get props => [user];
}

class CreateUserFailure extends LoginState {
  final UserFailure failure;

  CreateUserFailure(this.failure);
  @override
  List<Object> get props => [failure];
}
