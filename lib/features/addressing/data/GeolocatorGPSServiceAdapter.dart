import 'package:geolocator/geolocator.dart';
import 'package:grocery_brasil_app/core/config.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:meta/meta.dart';

import '../../../domain/Location.dart';
import 'GPSServiceAdapter.dart';

class GeolocatorGPSServiceAdapter implements GPSServiceAdapter {
  final GeolocatorPlatform geolocatorPlatform;

  GeolocatorGPSServiceAdapter({@required this.geolocatorPlatform});

  @override
  Future<Location> getCurrentLocation() async {
    try {
      final locationSeriveEnabled =
          await geolocatorPlatform.isLocationServiceEnabled();
      if (!locationSeriveEnabled) {
        throw AddressingException(
            messageId: MessageIds.UNEXPECTED, message: 'GPS not enabled');
      }
      final geoserivcePermission = await geolocatorPlatform.checkPermission();
      switch (geoserivcePermission) {
        case LocationPermission.denied:
        case LocationPermission.deniedForever:
          await _requestGeoservicePermission();
          break;
        default:
      }
      final position = await geolocatorPlatform.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high, timeLimit: gpsTimeout);
      return Location(lat: position.latitude, lon: position.longitude);
    } catch (e) {
      if (e is AddressingException) {
        throw e;
      }
      throw AddressingException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }

  Future<void> _requestGeoservicePermission() async {
    final geoserivcePermission = await geolocatorPlatform.requestPermission();

    switch (geoserivcePermission) {
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        throw AddressingException(
            messageId: MessageIds.UNEXPECTED, message: 'Not permitted');
        break;
      default:
    }
  }
}
