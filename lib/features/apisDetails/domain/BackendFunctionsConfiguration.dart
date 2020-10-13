import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BackendFunctionsConfiguration extends Equatable {
  final String host;
  final int port;
  final String scheme;
  final String path;

  BackendFunctionsConfiguration(
      {@required this.scheme,
      @required this.host,
      @required this.port,
      @required this.path});

  @override
  List<Object> get props => [host, port, scheme, path];

  factory BackendFunctionsConfiguration.fromJson(Map<String, dynamic> json) =>
      BackendFunctionsConfiguration(
          host: json['host'],
          path: json['path'],
          port: json['port'],
          scheme: json['scheme']);
}
