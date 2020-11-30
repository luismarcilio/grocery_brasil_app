import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Autocomplete extends Equatable {
  final String description;
  final String placeId;

  Autocomplete({@required this.description, @required this.placeId});

  @override
  List<Object> get props => [description, placeId];
}
