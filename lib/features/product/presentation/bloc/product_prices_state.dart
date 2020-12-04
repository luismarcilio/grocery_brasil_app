part of 'product_prices_bloc.dart';

abstract class ProductPricesState extends Equatable {
  const ProductPricesState();

  @override
  List<Object> get props => [];
}

class ProductPricesInitial extends ProductPricesState {}

class ProductPricesSearching extends ProductPricesState {}

class ProductPricesError extends ProductPricesState {
  final ProductFailure productFailure;

  ProductPricesError({@required this.productFailure});
}

class MininumProductPriceAvailable extends ProductPricesState {
  final ProductPrices productPrices;

  MininumProductPriceAvailable({@required this.productPrices});
}
