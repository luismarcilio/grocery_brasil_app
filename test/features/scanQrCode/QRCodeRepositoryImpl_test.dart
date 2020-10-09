import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/scanQrCode/data/QRCodeScanner.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCodeRepository.dart';
import 'package:mockito/mockito.dart';

class MockQRCodeScanner extends Mock implements QRCodeScanner {}

void main() {
  MockQRCodeScanner mockQRCodeScanner;
  QRCodeRepository qRCodeRepository;

  group('should scan the qrcode', () {
    mockQRCodeScanner = MockQRCodeScanner();
    qRCodeRepository = QRCodeRepositoryImpl(qrCodeScanner: mockQRCodeScanner);

    test('should return qrcode when successfull', () async {
      //setup
      final expected = QRCode(url: 'http://teste.com');
      when(mockQRCodeScanner.scanQrcode())
          .thenAnswer((realInvocation) async => expected);

      //act
      final actual = await qRCodeRepository.scanQrCode();
      //assert
      expect(actual, Right(expected));
      verify(mockQRCodeScanner.scanQrcode());
      verifyNoMoreInteractions(mockQRCodeScanner);
    });
    test('should return fail   when exception', () async {
      //setup
      final expected =
          QRCodeFailure(messageId: MessageIds.UNEXPECTED, message: 'erro');
      when(mockQRCodeScanner.scanQrcode()).thenThrow(
          QRCodeException(messageId: MessageIds.UNEXPECTED, message: 'erro'));

      //act
      final actual = await qRCodeRepository.scanQrCode();
      //assert
      expect(actual, Left(expected));
      verify(mockQRCodeScanner.scanQrcode());
      verifyNoMoreInteractions(mockQRCodeScanner);
    });
  });
}
