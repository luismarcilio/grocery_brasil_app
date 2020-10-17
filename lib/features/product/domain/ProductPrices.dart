import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/domain/FiscalNote.dart';
import 'package:grocery_brasil_app/domain/PurchaseItem.dart';

class ProductPrices extends Equatable {
  final PurchaseItem item;
  final Company company;
  final double unityValue;

  ProductPrices({this.item, this.company, this.unityValue});

  @override
  // TODO: implement props
  List<Object> get props => [item, company, unityValue];
}
