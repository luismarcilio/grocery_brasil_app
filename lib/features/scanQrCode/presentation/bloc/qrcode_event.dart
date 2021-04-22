part of 'qrcode_bloc.dart';

abstract class QrcodeEvent extends Equatable {
  const QrcodeEvent();

  @override
  List<Object> get props => [];
}

class ReadQRCode extends QrcodeEvent {}

class ReadCodeReceived extends QrcodeEvent {
  final QRCode qrCode;
  ReadCodeReceived({@required this.qrCode});
}

class ReadCodeErrorReceived extends QrcodeEvent {
  final QRCodeFailure qrCodeFailure;
  ReadCodeErrorReceived({@required this.qrCodeFailure});
}
