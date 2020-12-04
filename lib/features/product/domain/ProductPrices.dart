import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/Company.dart';
import '../../../domain/Product.dart';
part 'ProductPrices.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductPrices extends Equatable {
  final Product product;
  final Company company;
  final double unityValue;
  final DateTime purchaseDate;

  ProductPrices(
      {this.product, this.company, this.unityValue, this.purchaseDate});

  factory ProductPrices.fromJson(Map<String, dynamic> json) =>
      _$ProductPricesFromJson(json);
  Map<String, dynamic> toJson() => _$ProductPricesToJson(this);

  @override
  String toString() => jsonEncode(this.toJson());

  @override
  List<Object> get props => [product, company, unityValue, purchaseDate];
}
