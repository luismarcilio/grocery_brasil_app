import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import 'PurchaseRepository.dart';

class DeletePurchaseUseCase implements UseCase<void, Params> {
  final PurchaseRepository repository;

  DeletePurchaseUseCase({@required this.repository});

  @override
  Future<Either<PurchaseFailure, void>> call(Params params) {
    return repository.deletePurchase(purchaseId: params.purchaseId);
  }
}

class Params extends Equatable {
  final String purchaseId;

  Params({@required this.purchaseId});

  @override
  List<Object> get props => [purchaseId];
}
