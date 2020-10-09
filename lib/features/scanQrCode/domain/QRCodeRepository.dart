import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeScanner.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';

abstract class QRCodeRepository {
  final QRCodeScanner qrCodeScanner;

  QRCodeRepository({this.qrCodeScanner});

  Future<Either<QRCodeFailure, QRCode>> scanQrCode();
}
