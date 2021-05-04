import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/User.dart';
import '../../domain/usecases/register.dart';

part 'registration_bloc_event.dart';
part 'registration_bloc_state.dart';

class RegistrationBloc
    extends Bloc<RegistrationBlocEvent, RegistrationBlocState> {
  final RegistrationUseCase registrationUseCase;

  RegistrationBloc({this.registrationUseCase})
      : super(RegistrationBlocInitial());

  @override
  Stream<RegistrationBlocState> mapEventToState(
    RegistrationBlocEvent event,
  ) async* {
    if (event is RegisterWithEmailAndPasswordEvent) {
      yield RegistrationBlocRunning();
      final result = await registrationUseCase(
          Params(email: event.email, password: event.password));
      yield* result.fold((registrationFailure) async* {
        yield RegistrationBlocFailed(failure: registrationFailure);
      }, (user) async* {
        yield RegistrationBlocSucceeded(user: user);
      });
    }
  }
}
