import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';

abstract class QRCodeScanner {
  Future<QRCode> scanQrcode();
}
