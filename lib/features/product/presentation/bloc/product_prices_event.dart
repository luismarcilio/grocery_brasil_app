part of 'product_prices_bloc.dart';

abstract class ProductPricesEvent extends Equatable {
  const ProductPricesEvent();

  @override
  List<Object> get props => [];
}

class GetMininumProductPriceAvailable extends ProductPricesEvent {
  final String productId;

  GetMininumProductPriceAvailable({@required this.productId});
}
