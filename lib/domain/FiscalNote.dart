import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Company.dart';

part 'FiscalNote.g.dart';

@JsonSerializable(explicitToJson: true)
class FiscalNote extends Equatable {
  final String accessKey;
  final String number;
  final String series;
  @JsonKey(fromJson: _dateTimeFromJsonOrTimestamp)
  final DateTime date;
  final Company company;

  @override
  String toString() => jsonEncode(this.toJson());

  FiscalNote(
      {this.accessKey, this.number, this.series, this.date, this.company});
  factory FiscalNote.fromJson(Map<String, dynamic> json) =>
      _$FiscalNoteFromJson(json);
  Map<String, dynamic> toJson() => _$FiscalNoteToJson(this);

  @override
  List<Object> get props => [accessKey, number, series, date, company];

  static DateTime _dateTimeFromJsonOrTimestamp(dynamic input) {
    if (input is String) {
      return DateTime.parse(input);
    }
    if (input is Timestamp) {
      return DateTime.fromMillisecondsSinceEpoch(input.millisecondsSinceEpoch);
    }
    throw Exception(
        '$input: ${input.runtimeType.toString()} cannot be converted to DateTime');
  }
}
