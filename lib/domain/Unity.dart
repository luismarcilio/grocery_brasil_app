import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Unity.g.dart';

@JsonSerializable()
class Unity extends Equatable {
  final String name;

  Unity({this.name});

  factory Unity.fromJson(Map<String, dynamic> json) => _$UnityFromJson(json);
  Map<String, dynamic> toJson() => _$UnityToJson(this);

  @override
  String toString() {
    return 'name:$name';
  }

  @override
  List<Object> get props => [name];
}
