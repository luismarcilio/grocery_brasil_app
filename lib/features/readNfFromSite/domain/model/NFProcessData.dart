import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

typedef OnPageFinishedType = void Function(String);

class NFProcessData extends Equatable {
  final String initialUrl;
  final String accessKey;
  final String state;
  final String javascriptFunctions;

  const NFProcessData(
      {@required this.initialUrl,
      @required this.accessKey,
      @required this.state,
      @required this.javascriptFunctions});

  @override
  List<Object> get props => [initialUrl, accessKey, state, javascriptFunctions];

  @override
  toString() {
    return ('NFProcessData: {initialUrl:$initialUrl, accessKey:$accessKey, state:$state javascriptFunctions:$javascriptFunctions}');
  }

  factory NFProcessData.fromJson(Map<String, dynamic> json) {
    return NFProcessData(
        accessKey: json['accessKey'],
        initialUrl: json['initialUrl'],
        state: json['state'],
        javascriptFunctions: json['javascriptFunctions']);
  }
}
