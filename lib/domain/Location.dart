import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'Location.g.dart';

@JsonSerializable()
class Location extends Equatable {
  final double lat;
  final double lon;

  Location({@required this.lat, @required this.lon});

  @override
  List<Object> get props => [lat, lon];

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  factory Location.fromGoogleapisJson(Map<String, dynamic> json) =>
      Location(lat: json['lat'], lon: json['lng']);

  @override
  String toString() => jsonEncode(this.toJson());
}
