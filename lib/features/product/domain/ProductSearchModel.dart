import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/Unity.dart';

part 'ProductSearchModel.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductSearchModel extends Equatable {
  final String eanCode;
  final String name;
  final String ncmCode;
  final bool normalized;
  final String thumbnail;
  final Unity unity;

  ProductSearchModel(
      {this.eanCode,
      this.name,
      this.ncmCode,
      this.normalized,
      this.thumbnail,
      this.unity});

  @override
  List<Object> get props =>
      [eanCode, name, ncmCode, normalized, thumbnail, unity];

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSearchModelToJson(this);

  @override
  String toString() => jsonEncode(this.toJson());
}
