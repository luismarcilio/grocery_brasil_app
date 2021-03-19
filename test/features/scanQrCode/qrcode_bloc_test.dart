import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/core/usecases/usecase.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/QRCode.dart';
import 'package:grocery_brasil_app/features/scanQrCode/domain/ScanQrCodeUseCase.dart';
import 'package:grocery_brasil_app/features/scanQrCode/presentation/bloc/qrcode_bloc.dart';
import 'package:mockito/mockito.dart';

class MockScanQRCode extends Mock implements ScanQRCode {}

void main() {
  MockScanQRCode mockScanQRCode;

  group("should read qrcode", () {
    final expected = QRCode(url: 'http://teste.com');
    mockScanQRCode = MockScanQRCode();
    setUp(() {
      when(mockScanQRCode.call(NoParams()))
          .thenAnswer((realInvocation) async => Right(expected));
    });
    blocTest('should register when passed login and password',
        build: () => QrcodeBloc(scanQRCode: mockScanQRCode),
        act: (bloc) => bloc.add(ReadQRCode()),
        expect: () => [QrcodeReading(), QrcodeReadDone(qrCode: expected)]);
  });

  group("should fail when a feilure occurs", () {
    final expected =
        QRCodeFailure(messageId: MessageIds.UNEXPECTED, message: 'message');
    mockScanQRCode = MockScanQRCode();
    setUp(() {
      when(mockScanQRCode.call(NoParams()))
          .thenAnswer((realInvocation) async => Left(expected));
    });
    blocTest('should register when passed login and password',
        build: () => QrcodeBloc(scanQRCode: mockScanQRCode),
        act: (bloc) => bloc.add(ReadQRCode()),
        expect: () => [QrcodeReading(), QrcodeReadError(failure: expected)]);
  });
}
