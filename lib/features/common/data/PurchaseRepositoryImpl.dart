import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/Purchase.dart';
import '../../login/data/datasources/AuthenticationDataSource.dart';
import '../../readNfFromSite/data/NFDataSource.dart';
import '../../readNfFromSite/domain/model/NfHtmlFromSite.dart';
import '../domain/PurchaseRepository.dart';
import 'PurchaseDataSource.dart';

class PurchaseRepositoryImpl extends PurchaseRepository {
  final NFDataSource nfDataSource;
  final PurchaseDataSource purchaseDataSource;
  final AuthenticationDataSource authenticationDataSource;

  PurchaseRepositoryImpl(
      {@required this.authenticationDataSource,
      @required this.purchaseDataSource,
      @required this.nfDataSource});
  @override
  Future<Either<PurchaseFailure, NfHtmlFromSite>> save(
      {NfHtmlFromSite nfHtmlFromSite}) async {
    try {
      final NfHtmlFromSite result =
          await nfDataSource.save(nfHtmlFromSite: nfHtmlFromSite);
      return Right(result);
    } catch (e) {
      print('Erro: ${e.toString()}');
      if (e is PurchaseException) {
        return Left(
            PurchaseFailure(messageId: e.messageId, message: e.message));
      }
      return Left(
        PurchaseFailure(
            messageId: MessageIds.UNEXPECTED,
            message: 'Operação falhou. (Mensagem original: [${e.toString()}])'),
      );
    }
  }

  @override
  Future<Either<Failure, Stream<List<Purchase>>>> listPurchaseResume() async {
    try {
      final Stream<List<Purchase>> purchaseStream = purchaseDataSource
          .listPurchaseResume(userId: authenticationDataSource.getUserId());
      return (Right(purchaseStream));
    } catch (e) {
      if (e is PurchaseException) {
        return Left(
          PurchaseFailure(messageId: e.messageId, message: e.message),
        );
      }
      return Left(
        PurchaseFailure(
            messageId: MessageIds.UNEXPECTED,
            message: 'Operação falhou. (Mensagem original: [${e.toString()}])'),
      );
    }
  }

  @override
  Future<Either<Failure, Purchase>> getPurchaseById({String purchaseId}) async {
    try {
      final Purchase purchase = await purchaseDataSource.getPurchaseById(
          purchaseId: purchaseId, userId: authenticationDataSource.getUserId());
      return (Right(purchase));
    } catch (e) {
      if (e is PurchaseException) {
        return Left(
          PurchaseFailure(messageId: e.messageId, message: e.message),
        );
      }
      return Left(
        PurchaseFailure(
            messageId: MessageIds.UNEXPECTED,
            message: 'Operação falhou. (Mensagem original: [${e.toString()}])'),
      );
    }
  }
}
