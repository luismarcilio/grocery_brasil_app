import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/config.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/features/addressing/data/GPSServiceAdapter.dart';
import 'package:grocery_brasil_app/features/addressing/data/GeolocatorGPSServiceAdapter.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';

class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

main() {
  MockGeolocatorPlatform mockGeolocatorPlatform;
  GPSServiceAdapter sut;
  setUp(() {
    mockGeolocatorPlatform = MockGeolocatorPlatform();
    sut =
        GeolocatorGPSServiceAdapter(geolocatorPlatform: mockGeolocatorPlatform);
  });
  group('GeolocatorGPSServiceAdapter', () {
    test('should return the Location', () async {
      //setup
      final expected = Location(lat: 10.0, lon: 11.0);
      when(mockGeolocatorPlatform.isLocationServiceEnabled())
          .thenAnswer((realInvocation) async => true);

      when(mockGeolocatorPlatform.checkPermission())
          .thenAnswer((realInvocation) async => LocationPermission.whileInUse);

      when(mockGeolocatorPlatform.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high, timeLimit: gpsTimeout))
          .thenAnswer((realInvocation) async => Position(
              latitude: 10.0,
              longitude: 11.0,
              timestamp: null,
              accuracy: null,
              altitude: null,
              heading: null,
              speed: null,
              speedAccuracy: null));

      //act
      Location actual = await sut.getCurrentLocation();
      //assert
      expect(expected, equals(actual));
      verify(mockGeolocatorPlatform.isLocationServiceEnabled());
      verify(mockGeolocatorPlatform.checkPermission());
      verify(mockGeolocatorPlatform.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high, timeLimit: gpsTimeout));

      verifyNoMoreInteractions(mockGeolocatorPlatform);
    });

    test('should request permission once when not granted', () async {
      //setup
      final expected = Location(lat: 10.0, lon: 11.0);
      when(mockGeolocatorPlatform.isLocationServiceEnabled())
          .thenAnswer((realInvocation) async => true);

      when(mockGeolocatorPlatform.checkPermission())
          .thenAnswer((realInvocation) async => LocationPermission.denied);
      when(mockGeolocatorPlatform.requestPermission())
          .thenAnswer((realInvocation) async => LocationPermission.whileInUse);

      when(mockGeolocatorPlatform.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high, timeLimit: gpsTimeout))
          .thenAnswer((realInvocation) async => Position(
              latitude: 10.0,
              longitude: 11.0,
              timestamp: null,
              accuracy: null,
              altitude: null,
              heading: null,
              speed: null,
              speedAccuracy: null));

      //act
      Location actual = await sut.getCurrentLocation();
      //assert
      expect(expected, equals(actual));
      verify(mockGeolocatorPlatform.isLocationServiceEnabled());
      verify(mockGeolocatorPlatform.checkPermission());
      verify(mockGeolocatorPlatform.requestPermission());
      verify(mockGeolocatorPlatform.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high, timeLimit: gpsTimeout));

      verifyNoMoreInteractions(mockGeolocatorPlatform);
    });

    test('should throw error when permission not granted', () async {
      //setup
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Not permitted');
      when(mockGeolocatorPlatform.isLocationServiceEnabled())
          .thenAnswer((realInvocation) async => true);

      when(mockGeolocatorPlatform.checkPermission())
          .thenAnswer((realInvocation) async => LocationPermission.denied);
      when(mockGeolocatorPlatform.requestPermission())
          .thenAnswer((realInvocation) async => LocationPermission.denied);

      //act
      //assert
      expect(() async => await sut.getCurrentLocation(), throwsA(expected));
      await untilCalled(mockGeolocatorPlatform.isLocationServiceEnabled());
      await untilCalled(mockGeolocatorPlatform.checkPermission());
      await untilCalled(mockGeolocatorPlatform.requestPermission());

      verify(mockGeolocatorPlatform.isLocationServiceEnabled());
      verify(mockGeolocatorPlatform.checkPermission());
      verify(mockGeolocatorPlatform.requestPermission());

      verifyNoMoreInteractions(mockGeolocatorPlatform);
    });
    test('should throw error  when LocationService is disabled', () {
      //setup
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'GPS not enabled');
      when(mockGeolocatorPlatform.isLocationServiceEnabled())
          .thenAnswer((realInvocation) async => false);

      //act
      //assert
      expect(() async => sut.getCurrentLocation(), throwsA(expected));
      verify(mockGeolocatorPlatform.isLocationServiceEnabled());
      verifyNoMoreInteractions(mockGeolocatorPlatform);
    });
    test('should throw AddressingException when some error occurs', () {
      //setup
      final expected = AddressingException(
          messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
      when(mockGeolocatorPlatform.isLocationServiceEnabled())
          .thenThrow(Exception('some error'));
      //act
      //assert
      expect(() async => await sut.getCurrentLocation(), throwsA(expected));
      verify(mockGeolocatorPlatform.isLocationServiceEnabled());

      verifyNoMoreInteractions(mockGeolocatorPlatform);
    });
  });
}
