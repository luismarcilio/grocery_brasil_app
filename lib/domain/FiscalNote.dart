import 'package:equatable/equatable.dart';

import 'Address.dart';

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

  @override
  List<Object> get props => [accessKey, number, series, date, company];

  factory FiscalNote.fromJson(Map<String, dynamic> json) {
    final FiscalNote _fiscalNote = FiscalNote(
        company: Company.fromJson(json['company']),
        number: json['number'],
        accessKey: json['accessKey'],
        date: json['date'].toDate(),
        series: json['series']);
    return _fiscalNote;
  }
}

class Company extends Equatable {
  final String name;
  final String taxIdentification;
  final Address address;

  Company({this.name, this.taxIdentification, this.address});

  @override
  List<Object> get props => [name, taxIdentification, address];

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        name: json['name'],
        taxIdentification: json['taxIdentification'],
        address: Address.fromJson(json['address']));
  }

  @override
  String toString() {
    return 'Company{name: $name, taxIdentification: $taxIdentification, address: $address}';
  }
}
