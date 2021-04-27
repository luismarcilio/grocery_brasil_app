part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class ShareContent extends ShareEvent {
  final Shareable shareable;
  ShareContent({@required this.shareable});
}
