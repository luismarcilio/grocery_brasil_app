import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../../domain/UpdateUserUseCase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UpdateUserUseCase updateUserUseCase;

  UserBloc({@required this.updateUserUseCase}) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UpdateUser) {
      yield* _mapUpdateUserEventToState(event);
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
}
