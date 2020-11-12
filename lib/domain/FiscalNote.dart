import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Company.dart';

part 'FiscalNote.g.dart';

@JsonSerializable()
class FiscalNote extends Equatable {
  final String accessKey;
  final String number;
  final String series;
  final DateTime date;
  final Company company;

  @override
  String toString() {
    return 'FiscalNote{accessKey: $accessKey, number: $number, series: $series, date: $date, company: $company}';
  }

  FiscalNote(
      {this.accessKey, this.number, this.series, this.date, this.company});
  factory FiscalNote.fromJson(Map<String, dynamic> json) =>
      _$FiscalNoteFromJson(json);
  Map<String, dynamic> toJson() => _$FiscalNoteToJson(this);

  @override
  List<Object> get props => [accessKey, number, series, date, company];
}
