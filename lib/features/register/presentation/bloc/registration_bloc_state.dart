part of 'registration_bloc_bloc.dart';

abstract class RegistrationBlocState extends Equatable {
  const RegistrationBlocState();

  @override
  List<Object> get props => [];
}

class RegistrationBlocInitial extends RegistrationBlocState {}

class RegistrationBlocRunning extends RegistrationBlocState {}

class RegistrationBlocSucceeded extends RegistrationBlocState {
  final User user;

  RegistrationBlocSucceeded({this.user});
}

class RegistrationBlocFailed extends RegistrationBlocState {
  final RegistrationFailure failure;

  RegistrationBlocFailed({this.failure});
}
