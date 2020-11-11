import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/Address.dart';
import 'ProductPrices.dart';
import 'ProductRepository.dart';

class ListProductsPricesByTextAndLocationUseCase
    extends UseCase<Stream<ProductPrices>, Params> {
  final ProductRepository productRepository;

  ListProductsPricesByTextAndLocationUseCase(
      {@required this.productRepository});

  @override
  Future<Either<ProductFailure, Stream<ProductPrices>>> call(params) {
    return productRepository.listProductsPricesByTextAndLocationUseCase(
        location: params.location, text: params.text);
  }
}

class Params extends Equatable {
  final Location location;
  final String text;

  Params({@required this.location, @required this.text});

  @override
  List<Object> get props => [location, text];
}