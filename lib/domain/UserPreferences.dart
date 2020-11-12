import 'package:json_annotation/json_annotation.dart';

part 'UserPreferences.g.dart';

@JsonSerializable()
class UserPreferences {
  int searchRadius;

  UserPreferences({this.searchRadius});
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}
