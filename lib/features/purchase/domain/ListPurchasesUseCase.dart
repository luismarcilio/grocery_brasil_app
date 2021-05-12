import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/Purchase.dart';
import '../../register/domain/usecases/register.dart';
import 'PurchaseRepository.dart';

class ListPurchasesUseCase
    implements UseCase<Stream<List<Purchase>>, NoParams> {
  final PurchaseRepository repository;

  ListPurchasesUseCase({@required this.repository});

  @override
  Future<Either<Failure, Stream<List<Purchase>>>> call(params) {
    return repository.listPurchaseResume();
  }
}

class NoParams extends Params {}
