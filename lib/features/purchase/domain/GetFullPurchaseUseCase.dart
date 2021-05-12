import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/Purchase.dart';
import 'PurchaseRepository.dart';

class GetFullPurchaseUseCase implements UseCase<Purchase, Params> {
  final PurchaseRepository repository;

  GetFullPurchaseUseCase({@required this.repository});

  @override
  Future<Either<Failure, Purchase>> call(params) {
    return repository.getPurchaseById(purchaseId: params.purchaseId);
  }
}

class Params extends Equatable {
  final String purchaseId;

  Params({@required this.purchaseId});

  @override
  List<Object> get props => [purchaseId];
}
