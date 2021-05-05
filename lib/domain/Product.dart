import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Unity.dart';

part 'Product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product extends Equatable {
  final String productId;
  final String name;
  final String eanCode;
  final String ncmCode;
  final Unity unity;
  final bool normalized;
  final String thumbnail;
  Product(
      {this.productId,
      this.name,
      this.eanCode,
      this.ncmCode,
      this.unity,
      this.normalized,
      this.thumbnail});

  @override
  String toString() => jsonEncode(this.toJson());

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
  @override
  List<Object> get props =>
      [productId, name, eanCode, ncmCode, unity, normalized, thumbnail];
}
