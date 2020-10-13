import 'package:equatable/equatable.dart';

import 'Unity.dart';

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
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      eanCode: json['eanCode'],
      ncmCode: json['ncmCode'],
      normalized: json['normalized'],
      thumbnail: json['thumbnail'],
      unity: Unity.fromJson(json['unity']),
    );
  }

  @override
  String toString() {
    return 'name:$name, '
        'eanCode: $eanCode, '
        'ncmCode: $ncmCode, '
        'unity: ${unity.toString()}, '
        'normalized: $normalized, '
        'thumbnail: $thumbnail';
  }

  @override
  List<Object> get props =>
      [name, eanCode, ncmCode, unity, normalized, thumbnail];
}
