import 'package:equatable/equatable.dart';

class QRCode extends Equatable {
  final String url;

  QRCode({this.url});

  @override
  List<Object> get props => [url];
}
