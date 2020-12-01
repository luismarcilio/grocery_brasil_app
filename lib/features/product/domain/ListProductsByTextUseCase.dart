import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'ProductSearchModel.dart';
import 'ProductService.dart';

class ListProductsByTextUseCase
    extends UseCase<Stream<ProductSearchModel>, Params> {
  final ProductService productService;

  ListProductsByTextUseCase({@required this.productService});

  @override
  Future<Either<ProductFailure, Stream<ProductSearchModel>>> call(params) {
    return productService.listProductsByText(text: params.text);
  }
}

class Params extends Equatable {
  final String text;

  Params({@required this.text});

  @override
  List<Object> get props => [text];
}
