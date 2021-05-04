import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/GetMinPriceProductByUserByProductIdUseCase.dart';
import '../../domain/GetPricesProductByUserByProductIdUseCase.dart';
import '../../domain/ProductPrices.dart';

part 'product_prices_event.dart';
part 'product_prices_state.dart';

class ProductPricesBloc extends Bloc<ProductPricesEvent, ProductPricesState> {
  ProductPricesBloc(
      {@required this.getMinPriceProductByUserByProductIdUseCase,
      @required this.getPricesProductByUserByProductIdUseCase})
      : super(ProductPricesInitial());

  final GetMinPriceProductByUserByProductIdUseCase
      getMinPriceProductByUserByProductIdUseCase;

  final GetPricesProductByUserByProductIdUseCase
      getPricesProductByUserByProductIdUseCase;
  @override
  Stream<ProductPricesState> mapEventToState(
    ProductPricesEvent event,
  ) async* {
    if (event is GetMininumProductPriceAvailable) {
      yield* _mapGetMinPPToState(event);
    } else if (event is GetProductPrices) {
      yield* _mapGetProductPricesToState(event);
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

  Stream<ProductPricesState> _mapGetProductPricesToState(
      GetProductPrices event) async* {
    yield ProductPricesSearching();
    final searchResult =
        await this.getPricesProductByUserByProductIdUseCase(event.productId);
    yield* searchResult.fold((l) async* {
      yield ProductPricesError(productFailure: l);
    }, (r) async* {
      yield ProductPricesAvailable(productPrices: r);
    });
  }
}
