import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../domain/Product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial());

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    // if (event is GetProductByNf) {
    //   yield ProductLoading();
    // }
  }
}
