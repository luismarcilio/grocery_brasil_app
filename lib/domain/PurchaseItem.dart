import 'package:equatable/equatable.dart';

import 'Product.dart';
import 'Unity.dart';

class PurchaseItem extends Equatable {
  final Product product;
  final Unity unity;
  final double unityValue;
  final double units;
  final double totalValue;

  PurchaseItem(
      {this.product, this.unity, this.unityValue, this.units, this.totalValue});

  @override
  List<Object> get props => [product, unity, unityValue, units, totalValue];

  factory PurchaseItem.fromJson(Map<String, dynamic> json) => PurchaseItem(
      product: Product.fromJson(json['product']),
      unity: Unity.fromJson(json['unity']),
      unityValue: json['unityValue'].toDouble(),
      units: json['units'].toDouble(),
      totalValue: json['totalValue'].toDouble());
}
