import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserPreferences.g.dart';

@JsonSerializable()
class UserPreferences extends Equatable {
  final int searchRadius;

  UserPreferences({this.searchRadius});
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  @override
  List<Object> get props => [searchRadius];

  @override
  String toString() => jsonEncode(this.toJson());
}
