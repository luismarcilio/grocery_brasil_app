part of 'readnf_bloc.dart';

abstract class ReadnfEvent extends Equatable {
  const ReadnfEvent();

  @override
  List<Object> get props => [];
}

class GetDetailsFromUrl extends ReadnfEvent {
  final String url;
  GetDetailsFromUrl({@required this.url});
}

class SaveNfEvent extends ReadnfEvent {
  final NfHtmlFromSite nfHtmlFromSite;

  SaveNfEvent({@required this.nfHtmlFromSite}) {
    print("html: ${nfHtmlFromSite.html}");
  }
}
