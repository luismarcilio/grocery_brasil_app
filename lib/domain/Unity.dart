import 'package:equatable/equatable.dart';

class Unity extends Equatable {
  final String name;
  Unity({this.name});
  factory Unity.fromJson(Map<String, dynamic> json) =>
      Unity(name: json['name']);
  @override
  String toString() {
    return 'name:$name';
  }

  @override
  List<Object> get props => [name];
}
