import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NfHtmlFromSite extends Equatable {
  final String html;
  final String uf;

  const NfHtmlFromSite({@required this.html, @required this.uf});

  @override
  List<Object> get props => [html, uf];
}
