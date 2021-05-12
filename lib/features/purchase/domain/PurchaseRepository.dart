import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/Purchase.dart';
import '../../readNfFromSite/domain/model/NfHtmlFromSite.dart';

abstract class PurchaseRepository {
  Future<Either<PurchaseFailure, NfHtmlFromSite>> save(
      {@required NfHtmlFromSite nfHtmlFromSite});

  Future<Either<Failure, Stream<List<Purchase>>>> listPurchaseResume();
  Future<Either<Failure, Purchase>> getPurchaseById(
      {@required String purchaseId});
  Future<Either<PurchaseFailure, void>> deletePurchase(
      {@required String purchaseId});
}
