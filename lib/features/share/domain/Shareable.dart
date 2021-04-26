import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:meta/meta.dart';

class Shareable extends Equatable {
  final dynamic content;
  final ShareFormat format;

  Shareable({@required this.content, @required this.format});
  @override
  List<Object> get props => [content, format];
}
