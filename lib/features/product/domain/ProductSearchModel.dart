import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/Unity.dart';

part 'ProductSearchModel.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductSearchModel extends Equatable {
  final String productId;
  final String eanCode;
  final String name;
  final String ncmCode;
  final bool normalized;
  final String thumbnail;
  final Unity unity;

  ProductSearchModel(
      {this.productId,
      this.eanCode,
      this.name,
      this.ncmCode,
      this.normalized,
      this.thumbnail,
      this.unity});

  @override
  List<Object> get props =>
      [productId, eanCode, name, ncmCode, normalized, thumbnail, unity];

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSearchModelToJson(this);

  factory ProductSearchModel.fromElasticSearch(Map<String, dynamic> json) {
    return ProductSearchModel(
      productId: json['_id'],
      eanCode: json['_source']['eanCode'] as String,
      name: json['_source']['name'] as String,
      ncmCode: json['_source']['ncmCode'] as String,
      normalized: json['_source']['normalized'] as bool,
      thumbnail: json['_source']['thumbnail'] as String,
      unity: json['_source']['unity'] == null
          ? null
          : Unity.fromJson(json['_source']['unity'] as Map<String, dynamic>),
    );
  }

  factory ProductSearchModel.fromTextSearch(Map<String, dynamic> json) {
    return ProductSearchModel(
      productId: json['id'],
      eanCode: json['eanCode'] as String,
      name: json['name'] as String,
      ncmCode: json['ncmCode'] as String,
      normalized: json['normalized'] as bool,
      thumbnail: json['thumbnail'] as String,
      unity: json['unity'] == null
          ? null
          : Unity.fromJson(json['unity'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() => jsonEncode(this.toJson());
}
