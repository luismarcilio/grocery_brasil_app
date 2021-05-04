import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/utils/Utils.dart';
import '../../../domain/Company.dart';
import '../../../domain/Product.dart';

part 'ProductPrices.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductPrices extends Equatable {
  final Product product;
  final Company company;
  final double unityValue;
  @JsonKey(fromJson: dateTimeFromJsonOrTimestamp)
  final DateTime date;

  ProductPrices({this.product, this.company, this.unityValue, this.date});

  factory ProductPrices.fromJson(Map<String, dynamic> json) =>
      _$ProductPricesFromJson(json);
  Map<String, dynamic> toJson() => _$ProductPricesToJson(this);

  @override
  String toString() => jsonEncode(this.toJson());

  @override
  List<Object> get props => [product, company, unityValue, date];
}
