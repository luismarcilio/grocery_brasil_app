import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/Purchase.dart';
import '../../readNfFromSite/domain/model/NfHtmlFromSite.dart';

abstract class PurchaseRepository {
  Future<Either<NfFailure, NfHtmlFromSite>> save(
      {@required NfHtmlFromSite nfHtmlFromSite});

  Future<Either<Failure, Stream<Purchase>>> listNFOrderedByDateDesc();
}
