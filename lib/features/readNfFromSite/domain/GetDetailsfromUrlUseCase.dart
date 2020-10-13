import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'DetailsFromUrlRepository.dart';
import 'model/NFProcessData.dart';

class GetDetailsfromUrlUseCase implements UseCase<NFProcessData, Params> {
  final DetailsFromUrlRepository repository;

  GetDetailsfromUrlUseCase({this.repository});

  @override
  Future<Either<NFProcessDataFailure, NFProcessData>> call(
      Params params) async {
    return repository(url: params.url);
  }
}

class Params extends Equatable {
  final String url;

  Params({@required this.url});

  @override
  List<Object> get props => [url];
}
