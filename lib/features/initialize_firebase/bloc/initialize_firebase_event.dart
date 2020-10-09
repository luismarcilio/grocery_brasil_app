part of 'initialize_firebase_bloc.dart';

abstract class InitializeFirebaseEvent extends Equatable {
  const InitializeFirebaseEvent();
}

class InitalizeFirebase extends InitializeFirebaseEvent {
  @override
  List<Object> get props => [];
}
