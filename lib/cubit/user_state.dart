part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();

  @override
  List<Object> get props => props;
}

class UserLoading extends UserState {
  const UserLoading();

  @override
  List<Object> get props => props;
}

class UserLoaded extends UserState {
  final User user;
  const UserLoaded(this.user);

  @override
  List<Object> get props => props;
}

class UserSaving extends UserState {
  const UserSaving();

  @override
  List<Object> get props => props;
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object> get props => props;
}
