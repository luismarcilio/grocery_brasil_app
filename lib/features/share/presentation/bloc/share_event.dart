part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class ShareText extends ShareEvent {
  final String textToShare;
  ShareText({@required this.textToShare});
}
