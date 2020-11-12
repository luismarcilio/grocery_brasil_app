import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Address.dart';

part 'Company.g.dart';

@JsonSerializable()
class Company extends Equatable {
  final String name;
  final String taxIdentification;
  final Address address;

  Company({this.name, this.taxIdentification, this.address});

  @override
  List<Object> get props => [name, taxIdentification, address];

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  String toString() {
    return 'Company{name: $name, taxIdentification: $taxIdentification, address: $address}';
  }
}
