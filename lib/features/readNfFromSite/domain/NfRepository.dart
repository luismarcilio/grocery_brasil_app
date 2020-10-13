import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import 'model/NfHtmlFromSite.dart';

abstract class NfRepository {
  Future<Either<NfFailure, NfHtmlFromSite>> save(
      {@required NfHtmlFromSite nfHtmlFromSite});
}
