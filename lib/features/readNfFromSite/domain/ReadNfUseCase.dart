import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'NfHtmlFromSite.dart';
import 'ReadNFRepository.dart';

class ReadNFUseCase implements UseCase<NfHtmlFromSite, Params> {
  final ReadNFRepository repository;

  ReadNFUseCase(this.repository);

  @override
  Future<Either<NfHtmlFromSiteFailure, NfHtmlFromSite>> call(
      Params params) async {
    return await repository.readHtml(params.url);
  }
}

class Params extends Equatable {
  final String url;

  Params({@required this.url});

  @override
  List<Object> get props => [url];
}
