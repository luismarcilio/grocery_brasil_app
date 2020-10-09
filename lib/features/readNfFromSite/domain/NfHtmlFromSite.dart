import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NfHtmlFromSite extends Equatable {
  final String html;

  NfHtmlFromSite({@required this.html});

  @override
  List<Object> get props => [html];
}
