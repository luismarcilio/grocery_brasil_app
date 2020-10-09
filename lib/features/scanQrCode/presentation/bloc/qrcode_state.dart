part of 'qrcode_bloc.dart';

abstract class QrcodeState extends Equatable {
  const QrcodeState();

  @override
  List<Object> get props => [];
}

class QrcodeInitial extends QrcodeState {}

class QrcodeReading extends QrcodeState {}

class QrcodeReadDone extends QrcodeState {
  final QRCode qrCode;

  QrcodeReadDone({this.qrCode});
}

class QrcodeReadError extends QrcodeState {
  final QRCodeFailure failure;

  QrcodeReadError({this.failure});
}
