import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/features/addressing/data/AddressingDataSource.dart';
import 'package:grocery_brasil_app/features/addressing/data/AddressingDataSourceImpl.dart';
import 'package:grocery_brasil_app/features/addressing/data/AddressingServiceAdapter.dart';
import 'package:grocery_brasil_app/features/addressing/data/GPSServiceAdapter.dart';
import 'package:mockito/mockito.dart';

class MockAddressingServiceAdapter extends Mock
    implements AddressingServiceAdapter {}

class MockGPSServiceAdapter extends Mock implements GPSServiceAdapter {}

main() {
  MockAddressingServiceAdapter mockAddressingServiceAdapter =
      MockAddressingServiceAdapter();
  MockGPSServiceAdapter mockGPSServiceAdapter = MockGPSServiceAdapter();
  AddressingDataSource sut = AddressingDataSourceImpl(
      addressingServiceAdapter: mockAddressingServiceAdapter,
      gPSServiceAdapter: mockGPSServiceAdapter);

  group('AddressingDataSourceImpl', () {
    test('should return address', () async {
      //setup
      final expected = Address(rawAddress: 'some address');
      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenAnswer((realInvocation) async => Location(lat: 0.0, lon: 0.0));
      when(mockAddressingServiceAdapter
              .getAddressFromLocation(Location(lat: 0.0, lon: 0.0)))
          .thenAnswer((realInvocation) async => expected);
      //act
      final actual = await sut.getCurrentAddress();
      //assert
      expect(actual, equals(expected));
      verify(mockGPSServiceAdapter.getCurrentLocation());
      verifyNoMoreInteractions(mockGPSServiceAdapter);
      verify(mockAddressingServiceAdapter
          .getAddressFromLocation(Location(lat: 0.0, lon: 0.0)));
      verifyNoMoreInteractions(mockAddressingServiceAdapter);
    });

    test('should throw exception when an error occurs', () {
      //setup
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
      when(mockGPSServiceAdapter.getCurrentLocation())
          .thenThrow(Exception('some error'));

      //act
      //assert
      expect(() async => await sut.getCurrentAddress(), throwsA(expected));
    });
  });
}
