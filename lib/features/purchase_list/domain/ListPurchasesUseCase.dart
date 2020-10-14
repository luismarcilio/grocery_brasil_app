import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/features/common/domain/PurchaseRepository.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/Purchase.dart';
import '../../register/domain/usecases/register.dart';

class ListPurchasesUseCase implements UseCase<Stream<Purchase>, NoParams> {
  final PurchaseRepository repository;

  ListPurchasesUseCase({@required this.repository});

  @override
  Future<Either<Failure, Stream<Purchase>>> call(params) {
    return repository.listNFOrderedByDateDesc();
  }
}

class NoParams extends Params {}
