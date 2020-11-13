import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

typedef OnPageFinishedType = void Function(String);

class NFProcessData extends Equatable {
  final String initialUrl;
  final String accessKey;
  final String uf;
  final String javascriptFunctions;

  const NFProcessData(
      {@required this.initialUrl,
      @required this.accessKey,
      @required this.uf,
      @required this.javascriptFunctions});

  @override
  List<Object> get props => [initialUrl, accessKey, uf, javascriptFunctions];

  @override
  toString() {
    return ('NFProcessData: {initialUrl:$initialUrl, accessKey:$accessKey, uf:$uf javascriptFunctions:$javascriptFunctions}');
  }

  factory NFProcessData.fromJson(Map<String, dynamic> json) {
    return NFProcessData(
        accessKey: json['accessKey'],
        initialUrl: json['initialUrl'],
        uf: json['uf'],
        javascriptFunctions: json['javascriptFunctions']);
  }
}
