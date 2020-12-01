import 'package:equatable/equatable.dart';

import '../../../domain/Company.dart';
import '../../../domain/PurchaseItem.dart';

class ProductPrices extends Equatable {
  final PurchaseItem item;
  final Company company;
  final double unityValue;
  final DateTime purchaseDate;

  ProductPrices({this.item, this.company, this.unityValue, this.purchaseDate});

  @override
  List<Object> get props => [item, company, unityValue, purchaseDate];
}
