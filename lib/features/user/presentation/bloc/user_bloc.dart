import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../../domain/GetUserUseCase.dart';
import '../../domain/UpdateUserUseCase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetUserUseCase getUserUseCase;

  UserBloc({@required this.updateUserUseCase, @required this.getUserUseCase})
      : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UpdateUser) {
      yield* _mapUpdateUserEventToState(event);
    } else if (event is GetUser) {
      yield* _mapGetUserEventToState(event);
    }
  }

  Stream<UserState> _mapUpdateUserEventToState(UpdateUser event) async* {
    yield UserUpdating();
    final result = await this.updateUserUseCase(event.user);
    yield* result.fold((userFailure) async* {
      yield UserError(failure: userFailure);
    }, (user) async* {
      yield UserReady(user: user);
    });
  }

  Stream<UserState> _mapGetUserEventToState(GetUser event) async* {
    yield UserUpdating();
    final result = await this.getUserUseCase(NoParams());
    yield* result.fold((userFailure) async* {
      yield UserError(failure: userFailure);
    }, (user) async* {
      yield UserReady(user: user);
    });
  }
}
