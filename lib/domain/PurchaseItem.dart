import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Product.dart';
import 'Unity.dart';

part 'PurchaseItem.g.dart';

@JsonSerializable(explicitToJson: true)
class PurchaseItem extends Equatable {
  final Product product;
  final Unity unity;
  final double unityValue;
  final double units;
  final double totalValue;
  final double discount;

  @JsonSerializable()
  PurchaseItem(
      {this.product,
      this.unity,
      this.unityValue,
      this.units,
      this.totalValue,
      this.discount});

  @override
  List<Object> get props =>
      [product, unity, unityValue, units, totalValue, discount];

  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);

  @override
  String toString() => jsonEncode(this.toJson());
}
