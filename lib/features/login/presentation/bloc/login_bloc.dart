import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/core/usecases/asyncUseCase.dart'
    as asyncUseCase;
import 'package:grocery_brasil_app/features/logging/domain/InitializeLog.dart';
import 'package:grocery_brasil_app/features/user/domain/CreateUserUseCase.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/User.dart';
import '../../domain/usecases/AsyncLogin.dart';
import '../../domain/usecases/AuthenticateWithEmailAndPassword.dart';
import '../../domain/usecases/AuthenticateWithFacebook.dart';
import '../../domain/usecases/AuthenticateWithGoogle.dart';
import '../../domain/usecases/Logout.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticateWithEmailAndPassword authenticateWithEmailAndPassword;
  final AuthenticateWithFacebook authenticateWithFacebook;
  final AuthenticateWithGoogle authenticateWithGoogle;
  final Logout logout;
  final AsyncLogin asyncLogin;
  final CreateUserUseCase createUser;
  final InitializeLog initializeLog;

  LoginBloc(
      {@required this.authenticateWithEmailAndPassword,
      @required this.authenticateWithFacebook,
      @required this.authenticateWithGoogle,
      @required this.logout,
      @required this.asyncLogin,
      @required this.createUser,
      @required this.initializeLog})
      : super(LoginInitial()) {
    mapAsyncStateChanges(asyncLogin(asyncUseCase.NoParams()));
  }

  LoginState get initialState => LoginInitial();

  void mapAsyncStateChanges(
      Stream<Either<AsyncLoginFailure, User>> asyncStates) {
    asyncStates.listen((Either<AsyncLoginFailure, User> event) {
      print('event: $event');
      this.add(AsyncLoginEvent(event));
    });
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    print("login_bloc: $event");
    if (event is LoginWithUsernameAndPasswordEvent) {
      yield* _mapLoginWithUsernameAndPassword(event);
    } else if (event is LoginWithFacebookEvent) {
      yield* _mapLoginWithFacebook(event);
    } else if (event is LoginWithGoogleEvent) {
      yield* _mapLoginWithGoogle(event);
    } else if (event is LogoutEvent) {
      yield* _mapLogout(event);
    } else if (event is AsyncLoginEvent) {
      yield* _mapAsyncEvent(event);
    } else if (event is CreateUserEvent) {
      yield* _mapCreateUserEvent(event);
    }
  }

  Stream<LoginState> _mapCreateUserEvent(CreateUserEvent event) async* {
    yield UserCreating();
    final status = await createUser(event.user);
    yield status.fold(
        (failure) => CreateUserFailure(failure), (user) => LoginDone(user));
  }

  Stream<LoginState> _mapLoginWithUsernameAndPassword(
      LoginWithUsernameAndPasswordEvent event) async* {
    yield LoginRunning();
    print("LoginRunning()");
    Either<Failure, User> status = await authenticateWithEmailAndPassword
        .call(Params(event.email, event.password));
    print("status: $status");
    yield* status.fold((failure) async* {
      yield LoginError(failure);
    }, (user) async* {
      this.initializeLog.call(user);
      this.add(CreateUserEvent(user: user));
    });
  }

  Stream<LoginState> _mapLoginWithFacebook(
      LoginWithFacebookEvent event) async* {
    yield LoginRunning();
    Either<Failure, User> status =
        await authenticateWithFacebook.call(NoParams());
    yield* status.fold((failure) async* {
      yield LoginError(failure);
    }, (user) async* {
      this.initializeLog.call(user);
      this.add(CreateUserEvent(user: user));
    });
  }

  Stream<LoginState> _mapLoginWithGoogle(LoginWithGoogleEvent event) async* {
    yield LoginRunning();
    Either<Failure, User> status =
        await authenticateWithGoogle.call(NoParams());
    yield* status.fold((failure) async* {
      yield LoginError(failure);
    }, (user) async* {
      this.initializeLog.call(user);
      this.add(CreateUserEvent(user: user));
    });
  }

  Stream<LoginState> _mapLogout(LogoutEvent event) async* {
    yield LoginRunning();
    Either<Failure, bool> status = await logout.call(NoParams());
    yield status.fold(
        (failure) => LoginError(failure), (isLogout) => LogoutDone());
  }

  Stream<LoginState> _mapAsyncEvent(AsyncLoginEvent asyncLoginEvent) async* {
    yield LoginRunning();
    yield* asyncLoginEvent.event.fold((asyncLoginFailure) async* {
      switch (asyncLoginFailure.asyncLoginFailureId) {
        case AsyncLoginFailureId.OAUTH_FAILURE:
          yield LoginError(
            AuthenticationFailure(
                messageId: MessageIds.UNEXPECTED,
                message: asyncLoginFailure.message),
          );
          yield LogoutDone();
          break;
        case AsyncLoginFailureId.NOT_LOGGED_IN:
          yield LogoutDone();
          break;
        case AsyncLoginFailureId.GENERAL_FAILURE:
          yield LoginError(
            AuthenticationFailure(
                messageId: MessageIds.UNEXPECTED,
                message: asyncLoginFailure.message),
          );
          yield LogoutDone();

          break;
        case AsyncLoginFailureId.EMAIL_NOT_VERIFIED_FAILURE:
          yield LoginError(
            AuthenticationFailure(
                messageId: MessageIds.EMAIL_NOT_VERIFIED, message: ''),
          );
          yield LogoutDone();

          break;
        default:
          yield LoginError(
            AuthenticationFailure(
                messageId: MessageIds.UNEXPECTED, message: 'Unexpected'),
          );
          yield LogoutDone();

          break;
      }
    }, (user) async* {
      this.initializeLog.call(user);
      this.add(CreateUserEvent(user: user));
    });
  }
}
