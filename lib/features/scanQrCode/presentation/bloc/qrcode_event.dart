part of 'qrcode_bloc.dart';

abstract class QrcodeEvent extends Equatable {
  const QrcodeEvent();

  @override
  List<Object> get props => [];
}

class ReadQRCode extends QrcodeEvent {}
