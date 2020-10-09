import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeScanner.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeScannerImpl.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';
import 'package:mockito/mockito.dart';

class MockBarcodeScannerStub extends Mock implements BarcodeScannerStub {}

void main() {
  MockBarcodeScannerStub mockBarcodeScannerStub;
  QRCodeScanner qRCodeScanner;

  group('should scan the qrcode', () {
    setUp(() {
      mockBarcodeScannerStub = MockBarcodeScannerStub();
      qRCodeScanner =
          QRCodeScannerImpl(barcodeScannerStub: mockBarcodeScannerStub);
    });

    test('should return qrcode when successfull', () async {
      //setup
      final expected = QRCode(url: 'http://teste.com');
      when(mockBarcodeScannerStub.scan(options: anyNamed('options')))
          .thenAnswer((realInvocation) async => ScanResult(
              rawContent: 'http://teste.com', type: ResultType.Barcode));

      //act
      final actual = await qRCodeScanner.scanQrcode();
      //assert
      expect(actual, expected);
      verify(mockBarcodeScannerStub.scan(options: anyNamed('options')));
      verifyNoMoreInteractions(mockBarcodeScannerStub);
    });

    test('should throw cancel  when canceled', () async {
      //setup
      when(mockBarcodeScannerStub.scan(options: anyNamed('options')))
          .thenAnswer((realInvocation) async => ScanResult(
              rawContent: 'http://teste.com', type: ResultType.Cancelled));

      //assert
      expect(() async => await qRCodeScanner.scanQrcode(),
          throwsA(QRCodeException(messageId: MessageIds.CANCELLED)));
      verify(mockBarcodeScannerStub.scan(options: anyNamed('options')));
      verifyNoMoreInteractions(mockBarcodeScannerStub);
    });

    test('should throw unexpected  when returns error', () async {
      //setup
      when(mockBarcodeScannerStub.scan(options: anyNamed('options')))
          .thenAnswer((realInvocation) async => ScanResult(
              rawContent: 'http://teste.com', type: ResultType.Error));

      //assert
      expect(
          () async => await qRCodeScanner.scanQrcode(),
          throwsA(QRCodeException(
              messageId: MessageIds.UNEXPECTED, message: 'Erro lendo QRCode')));
      verify(mockBarcodeScannerStub.scan(options: anyNamed('options')));
      verifyNoMoreInteractions(mockBarcodeScannerStub);
    });

    test('should throw unexpected  when an exception is thrown', () async {
      //setup
      when(mockBarcodeScannerStub.scan(options: anyNamed('options')))
          .thenThrow(Exception('erro'));

      //assert
      expect(
          () async => await qRCodeScanner.scanQrcode(),
          throwsA(QRCodeException(
              messageId: MessageIds.UNEXPECTED,
              message:
                  'Erro lendo QRCode: Mensagem original: [Exception: erro]')));
      verify(mockBarcodeScannerStub.scan(options: anyNamed('options')));
      verifyNoMoreInteractions(mockBarcodeScannerStub);
    });
  });
}
