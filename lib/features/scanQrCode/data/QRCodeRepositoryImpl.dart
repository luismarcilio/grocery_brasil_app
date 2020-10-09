import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';
import '../domain/QRCode.dart';
import '../domain/QRCodeRepository.dart';
import 'QRCodeScanner.dart';

class QRCodeRepositoryImpl extends QRCodeRepository {
  final QRCodeScanner qrCodeScanner;

  QRCodeRepositoryImpl({this.qrCodeScanner});

  @override
  Future<Either<QRCodeFailure, QRCode>> scanQrCode() async {
    try {
      final qrCode = await qrCodeScanner.scanQrcode();
      return Right(qrCode);
    } catch (e) {
      if (e is QRCodeException) {
        final failure =
            QRCodeFailure(messageId: MessageIds.UNEXPECTED, message: e.message);
        return (Left(failure));
      }
      final failure = QRCodeFailure(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
      return (Left(failure));
    }
  }
}
