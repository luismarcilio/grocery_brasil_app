import 'package:barcode_scan/barcode_scan.dart';

Future<String> scanQrcode() async {
  final options = ScanOptions(restrictFormat: [BarcodeFormat.qr]);
  ScanResult scanResult = await BarcodeScanner.scan(options: options);

  return scanResult.rawContent;
}
