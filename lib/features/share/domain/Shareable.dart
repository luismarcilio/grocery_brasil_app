import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'ShareFormat.dart';

class Shareable extends Equatable {
  final ShareableContent content;
  final ShareFormat format;

  Shareable({@required this.content, @required this.format});
  @override
  List<Object> get props => [content, format];
}

class ShareableContent extends Equatable {
  final String text;
  final String subject;
  final dynamic data;
  final String filePath;

  ShareableContent({this.text, this.subject, this.data, this.filePath});

  @override
  List<Object> get props => [text, subject, data];
}
