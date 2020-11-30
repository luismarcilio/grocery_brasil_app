import 'package:equatable/equatable.dart';

import '../../../domain/Company.dart';
import '../../../domain/PurchaseItem.dart';

class ProductPrices extends Equatable {
  final PurchaseItem item;
  final Company company;
  final double unityValue;

  ProductPrices({this.item, this.company, this.unityValue});

  @override
  List<Object> get props => [item, company, unityValue];
}
