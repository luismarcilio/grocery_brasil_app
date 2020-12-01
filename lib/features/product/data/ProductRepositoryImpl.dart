import 'package:grocery_brasil_app/features/product/domain/ProductPrices.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/features/product/domain/ProductRepository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<Either<ProductFailure, Stream<ProductPrices>>>
      listProductsPricesByTextAndLocationUseCase(
          {Location location, String text}) {
    // TODO: implement listProductsPricesByTextAndLocationUseCase
    throw UnimplementedError();
  }
}
