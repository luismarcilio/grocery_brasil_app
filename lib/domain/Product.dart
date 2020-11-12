import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Unity.dart';

part 'Product.g.dart';

@JsonSerializable()
class Product extends Equatable {
  final String name;
  final String eanCode;
  final String ncmCode;
  final Unity unity;
  final bool normalized;
  final String thumbnail;
  Product(
      {this.name,
      this.eanCode,
      this.ncmCode,
      this.unity,
      this.normalized,
      this.thumbnail});

  @override
  String toString() {
    return 'name:$name, '
        'eanCode: $eanCode, '
        'ncmCode: $ncmCode, '
        'unity: ${unity.toString()}, '
        'normalized: $normalized, '
        'thumbnail: $thumbnail';
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
  @override
  List<Object> get props =>
      [name, eanCode, ncmCode, unity, normalized, thumbnail];
}
