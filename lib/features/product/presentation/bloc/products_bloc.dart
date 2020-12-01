import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/ListProductsByTextUseCase.dart';
import '../../domain/ProductSearchModel.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({@required this.listProductsByTextUseCase})
      : super(ProductsInitial());

  final ListProductsByTextUseCase listProductsByTextUseCase;

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    print("ProductsBloc: $event");

    if (event is SearchProductsByText) {
      yield* _mapSearchProductsByTextToState(event);
    }
  }

  Stream<ProductsState> _mapSearchProductsByTextToState(
      SearchProductsByText event) async* {
    yield ProductsSearching();
    final searchResult =
        await this.listProductsByTextUseCase(Params(text: event.text));
    yield* searchResult.fold((l) async* {
      yield ProductError(l);
    }, (r) async* {
      yield ProductsTextAvailable(products: r);
    });
  }
}
