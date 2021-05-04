import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/QRCode.dart';

part 'qrcode_event.dart';
part 'qrcode_state.dart';

class QrcodeBloc extends Bloc<QrcodeEvent, QrcodeState> {
  QrcodeBloc() : super(QrcodeInitial());
  @override
  Stream<QrcodeState> mapEventToState(
    QrcodeEvent event,
  ) async* {
    if (event is ReadQRCode) {
      yield QrcodeReading();
    }
    if (event is ReadCodeReceived) {
      yield QrcodeReadDone(qrCode: event.qrCode);
    }
    if (event is ReadCodeErrorReceived) {
      yield QrcodeReadError(failure: event.qrCodeFailure);
    }
  }
}
