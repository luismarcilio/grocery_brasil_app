import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/failures.dart';
import 'model/NFProcessData.dart';

abstract class DetailsFromUrlRepository {
  Future<Either<NFProcessDataFailure, NFProcessData>> call(
      {@required String url});
}
