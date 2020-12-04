import 'dart:async';
import 'package:grocery_brasil_app/features/product/domain/GetMinPriceProductByUserByProductIdUseCase.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductPrices.dart';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';

part 'product_prices_event.dart';
part 'product_prices_state.dart';

class ProductPricesBloc extends Bloc<ProductPricesEvent, ProductPricesState> {
  ProductPricesBloc({@required this.getMinPriceProductByUserByProductIdUseCase})
      : super(ProductPricesInitial());

  final GetMinPriceProductByUserByProductIdUseCase
      getMinPriceProductByUserByProductIdUseCase;

  @override
  Stream<ProductPricesState> mapEventToState(
    ProductPricesEvent event,
  ) async* {
    if (event is GetMininumProductPriceAvailable) {
      yield* _mapGetMinPPToState(event);
    }
  }

  Stream<ProductPricesState> _mapGetMinPPToState(
      GetMininumProductPriceAvailable event) async* {
    yield ProductPricesSearching();
    final searchResult =
        await this.getMinPriceProductByUserByProductIdUseCase(event.productId);
    yield* searchResult.fold((l) async* {
      yield ProductPricesError(productFailure: l);
    }, (r) async* {
      yield MininumProductPriceAvailable(productPrices: r);
    });
  }
}
