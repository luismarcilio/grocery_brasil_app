import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

part 'initialize_firebase_event.dart';
part 'initialize_firebase_state.dart';

class InitializeFirebaseBloc
    extends Bloc<InitializeFirebaseEvent, InitializeFirebaseState> {
  InitializeFirebaseBloc() : super(InitializeFirebaseInitial());

  @override
  Stream<InitializeFirebaseState> mapEventToState(
    InitializeFirebaseEvent event,
  ) async* {
    if (event is InitializeFirebaseEvent) {
      yield* _mapInitializeFirebaseEventState();
    }
  }

  Stream<InitializeFirebaseState> _mapInitializeFirebaseEventState() async* {
    yield FirebaseInitializing();
    try {
      await Firebase.initializeApp();
      yield FirebaseInitialized();
    } catch (error) {
      yield FirebaseError(error.toString());
    }
  }
}
