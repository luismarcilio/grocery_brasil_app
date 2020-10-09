import 'package:dartz/dartz.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCodeRepository.dart';

class ScanQRCode implements UseCase<QRCode, NoParams> {
  final QRCodeRepository repository;

  ScanQRCode(this.repository);

  @override
  Future<Either<QRCodeFailure, QRCode>> call(NoParams params) async {
    return await repository.scanQrCode();
  }
}
