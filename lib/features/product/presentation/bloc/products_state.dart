part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsSearching extends ProductsState {}

class ProductsTextAvailable extends ProductsState {
  final List<ProductSearchModel> products;

  ProductsTextAvailable({this.products});

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductsState {
  final ProductFailure failure;

  ProductError(ProductFailure l, {this.failure});

  @override
  List<Object> get props => [failure];
}
