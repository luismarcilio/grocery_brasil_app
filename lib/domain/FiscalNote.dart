import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../core/utils/Utils.dart';
import 'Company.dart';

part 'FiscalNote.g.dart';

@JsonSerializable(explicitToJson: true)
class FiscalNote extends Equatable {
  final String accessKey;
  final String number;
  final String series;
  @JsonKey(fromJson: dateTimeFromJsonOrTimestamp)
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
}
