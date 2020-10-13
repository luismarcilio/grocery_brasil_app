import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../domain/DetailsFromUrlRepository.dart';
import '../domain/model/NFProcessData.dart';
import 'DetailsFromUrlDataSource.dart';

class DetailsFromUrlRepositoryImpl extends DetailsFromUrlRepository {
  final DetailsFromUrlDataSource detailsFromUrldataSource;

  DetailsFromUrlRepositoryImpl({@required this.detailsFromUrldataSource});

  @override
  Future<Either<NFProcessDataFailure, NFProcessData>> call({String url}) async {
    try {
      final nfProcessData = await detailsFromUrldataSource(url: url);
      return Right(nfProcessData);
    } catch (e) {
      if (e is NFReaderException) {
        final nFProcessDataFailure = NFProcessDataFailure(
            messageId: e.messageId,
            message: 'Operação falhou. Mensagem original: [${e.message}]');
        return Left(nFProcessDataFailure);
      }
      final nFProcessDataFailure = NFProcessDataFailure(
          messageId: MessageIds.UNEXPECTED,
          message: 'Operação falhou. Mensagem original: [${e.toString()}]');
      return Left(nFProcessDataFailure);
    }
  }
}
