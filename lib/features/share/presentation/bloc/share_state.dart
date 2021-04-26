part of 'share_bloc.dart';

abstract class ShareState extends Equatable {
  const ShareState();

  @override
  List<Object> get props => [];
}

class ShareInitial extends ShareState {}

class Sharing extends ShareState {}

class Shared extends ShareState {}

class ShareError extends ShareState {
  final ShareFailure shareFailure;

  ShareError({@required this.shareFailure});
}
