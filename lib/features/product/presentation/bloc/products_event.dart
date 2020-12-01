part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class SearchProductsByText extends ProductsEvent {
  final String text;

  SearchProductsByText(this.text);
  @override
  List<Object> get props => [text];
}
