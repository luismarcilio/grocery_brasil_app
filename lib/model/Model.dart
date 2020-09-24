class Product {
  String name;
  String eanCode;
  String ncmCode;
  Unity unity;
  bool normalized;
  String thumbnail;
  Product(
      {this.name,
      this.eanCode,
      this.ncmCode,
      this.unity,
      this.normalized,
      this.thumbnail});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json['name'],
      eanCode: json['eanCode'],
      ncmCode: json['ncmCode'],
      normalized: json['normalized'],
      thumbnail: json['thumbnail'],
      unity: Unity.fromJson(json['unity']));

  @override
  String toString() {
    return 'name:$name, '
        'eanCode: $eanCode, '
        'ncmCode: $ncmCode, '
        'unity: ${unity.toString()}, '
        'normalized: $normalized, '
        'thumbnail: $thumbnail';
  }
}

class Unity {
  String name;
  Unity(this.name);
  factory Unity.fromJson(Map<String, dynamic> json) => Unity(json['name']);
  @override
  String toString() {
    return 'name:$name';
  }
}
