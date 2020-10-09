import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';

import 'NfHtmlFromSite.dart';

abstract class ReadNFRepository {
  Future<Either<NfHtmlFromSiteFailure, NfHtmlFromSite>> readHtml(String url);
}
