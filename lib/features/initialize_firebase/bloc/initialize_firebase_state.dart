part of 'initialize_firebase_bloc.dart';

abstract class InitializeFirebaseState extends Equatable {
  const InitializeFirebaseState();
}

class InitializeFirebaseInitial extends InitializeFirebaseState {
  @override
  List<Object> get props => [];
}

class FirebaseInitializing extends InitializeFirebaseState {
  @override
  List<Object> get props => [];
}

class FirebaseInitialized extends InitializeFirebaseState {
  @override
  List<Object> get props => [];
}

class FirebaseError extends InitializeFirebaseState {
  //TODO: switch to Failure
  final String error;

  FirebaseError(this.error);

  @override
  List<Object> get props => [error];
}
