import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/domain/Purchase.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../readNfFromSite/data/NFDataSource.dart';
import '../../readNfFromSite/domain/model/NfHtmlFromSite.dart';
import '../domain/PurchaseRepository.dart';

class PurchaseRepositoryImpl extends PurchaseRepository {
  final NFDataSource nfDataSource;

  PurchaseRepositoryImpl({@required this.nfDataSource});
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

  @override
  Future<Either<Failure, Stream<Purchase>>> listNFOrderedByDateDesc() {
    // TODO: implement listNFOrderedByDateDesc
    throw UnimplementedError();
  }
}
