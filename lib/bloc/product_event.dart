part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetProductByNf extends ProductEvent {
  final String nfAccessKey;

  GetProductByNf(this.nfAccessKey);

  @override
  List<Object> get props => [nfAccessKey];
}
