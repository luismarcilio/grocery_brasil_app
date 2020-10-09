import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';

import 'QRCodeScanner.dart';

class QRCodeScannerImpl extends QRCodeScanner {
  final BarcodeScannerStub barcodeScannerStub;

  QRCodeScannerImpl({this.barcodeScannerStub});

  @override
  Future<QRCode> scanQrcode() async {
    try {
      final scanResult = await barcodeScannerStub.scan(
          options: ScanOptions(restrictFormat: [BarcodeFormat.qr]));
      print('scanResult: $scanResult');
      switch (scanResult.type) {
        case ResultType.Cancelled:
          throw QRCodeException(messageId: MessageIds.CANCELLED);
          break;
        case ResultType.Error:
          throw QRCodeException(
              messageId: MessageIds.UNEXPECTED, message: 'Erro lendo QRCode');
          break;
        default:
      }
      return (QRCode(url: scanResult.rawContent));
    } catch (e) {
      if (e is QRCodeException) {
        throw e;
      }
      throw QRCodeException(
          messageId: MessageIds.UNEXPECTED,
          message: 'Erro lendo QRCode: Mensagem original: [${e.toString()}]');
    }
  }
}

class BarcodeScannerStub {
  Future<ScanResult> scan({ScanOptions options}) {
    return BarcodeScanner.scan(options: options);
  }
}
