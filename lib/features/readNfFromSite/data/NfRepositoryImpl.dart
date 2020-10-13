import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../domain/NfRepository.dart';
import '../domain/model/NfHtmlFromSite.dart';
import 'NFDataSource.dart';

class NfRepositoryImpl extends NfRepository {
  final NFDataSource nfDataSource;

  NfRepositoryImpl({@required this.nfDataSource});
  @override
  Future<Either<NfFailure, NfHtmlFromSite>> save(
      {NfHtmlFromSite nfHtmlFromSite}) async {
    try {
      final NfHtmlFromSite result =
          await nfDataSource.save(nfHtmlFromSite: nfHtmlFromSite);
      return Right(result);
    } catch (e) {
      print('Erro: ${e.toString()}');
      if (e is NfException) {
        return Left(NfFailure(messageId: e.messageId, message: e.message));
      }
      return Left(
        NfFailure(
            messageId: MessageIds.UNEXPECTED,
            message: 'Operação falhou: Mensagem original: [${e.toString()}]'),
      );
    }
  }
}
