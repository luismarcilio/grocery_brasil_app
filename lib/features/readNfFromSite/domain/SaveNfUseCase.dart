import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'NfRepository.dart';
import 'model/NfHtmlFromSite.dart';

class SaveNfUseCase implements UseCase<NfHtmlFromSite, Params> {
  final NfRepository nfRepository;

  SaveNfUseCase({@required this.nfRepository});

  @override
  Future<Either<NfFailure, NfHtmlFromSite>> call(Params params) {
    return nfRepository.save(nfHtmlFromSite: params.nfHtmlFromSite);
  }
}

class Params extends Equatable {
  final NfHtmlFromSite nfHtmlFromSite;

  Params({@required this.nfHtmlFromSite});

  @override
  List<Object> get props => [nfHtmlFromSite];
}
