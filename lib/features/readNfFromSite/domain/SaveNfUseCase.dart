import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../purchase/domain/PurchaseRepository.dart';
import 'model/NfHtmlFromSite.dart';

class SaveNfUseCase implements UseCase<NfHtmlFromSite, Params> {
  final PurchaseRepository purchaseRepository;

  SaveNfUseCase({@required this.purchaseRepository});

  @override
  Future<Either<PurchaseFailure, NfHtmlFromSite>> call(Params params) {
    return purchaseRepository.save(nfHtmlFromSite: params.nfHtmlFromSite);
  }
}

class Params extends Equatable {
  final NfHtmlFromSite nfHtmlFromSite;

  Params({@required this.nfHtmlFromSite});

  @override
  List<Object> get props => [nfHtmlFromSite];
}
