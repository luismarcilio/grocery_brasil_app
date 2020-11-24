part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserUpdating extends UserState {}

class UserReady extends UserState {
  final User user;
  UserReady({@required this.user});
}

class UserError extends UserState {
  final UserFailure failure;

  UserError({@required this.failure});
}
