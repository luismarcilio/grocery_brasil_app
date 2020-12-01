import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'Address.dart';
import 'UserPreferences.dart';

part 'User.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  final String email;
  final String userId;
  final bool emailVerified;
  final Address address;
  final UserPreferences preferences;

  User(
      {this.preferences,
      @required this.email,
      this.address,
      @required this.userId,
      this.emailVerified,
      String uid});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props =>
      [email, userId, emailVerified, address, preferences];

  @override
  String toString() => jsonEncode(this.toJson());
}
