import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/ScanQrCodeUseCase.dart';

part 'qrcode_event.dart';
part 'qrcode_state.dart';

class QrcodeBloc extends Bloc<QrcodeEvent, QrcodeState> {
  QrcodeBloc({this.scanQRCode}) : super(QrcodeInitial());
  final ScanQRCode scanQRCode;
  @override
  Stream<QrcodeState> mapEventToState(
    QrcodeEvent event,
  ) async* {
    if (event is ReadQRCode) {
      yield QrcodeReading();
      final result = await scanQRCode(NoParams());
      yield* result.fold((failure) async* {
        yield QrcodeReadError(failure: failure);
      }, (qrCode) async* {
        yield QrcodeReadDone(qrCode: qrCode);
      });
    }
  }
}
