part of 'registration_bloc_bloc.dart';

abstract class RegistrationBlocEvent extends Equatable {
  const RegistrationBlocEvent();

  @override
  List<Object> get props => [];
}

class RegisterWithEmailAndPasswordEvent extends RegistrationBlocEvent {
  final String email;
  final String password;

  RegisterWithEmailAndPasswordEvent({this.email, this.password});
  @override
  List<Object> get props => [email, password];
}
