import 'package:equatable/equatable.dart';

import '../../../domain/Company.dart';
import '../../../domain/Product.dart';

class ProductPrices extends Equatable {
  final Product product;
  final Company company;
  final double unityValue;
  final DateTime purchaseDate;

  ProductPrices(
      {this.product, this.company, this.unityValue, this.purchaseDate});

  @override
  List<Object> get props => [product, company, unityValue, purchaseDate];
}
