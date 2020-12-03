import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../../core/config.dart';
import '../../../core/errors/exceptions.dart';
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

  @override
  double distanceBetween({Location start, Location end}) {
    return geolocatorPlatform.distanceBetween(
        start.lat, start.lon, end.lat, end.lon);
  }

  @override
  List<Location> calculateTopLeftBottomRight({Location center, int distance}) {
    //bearing (clockwise from north)
    final double topLeftBrng = -45.0;
    final double bottomRightBrng = 135.0;
    final topLeft = _calculateCoordinates(
        center: center, distance: distance, bearing: topLeftBrng);
    final bottomRight = _calculateCoordinates(
        center: center, distance: distance, bearing: bottomRightBrng);
    return [topLeft, bottomRight];
  }

  Location _calculateCoordinates(
      {Location center, int distance, double bearing}) {
    //source: https://www.movable-type.co.uk/scripts/latlong.html
    // Formula:	φ2 = asin( sin φ1 ⋅ cos δ + cos φ1 ⋅ sin δ ⋅ cos θ )
    // λ2 = λ1 + atan2( sin θ ⋅ sin δ ⋅ cos φ1, cos δ − sin φ1 ⋅ sin φ2 )
    // where	φ is latitude, λ is longitude, θ is the bearing (clockwise from north), δ is the angular distance d/R;
    // d being the distance travelled, R the earth’s radius

    final double R = 6371.0e3;
    final double phi1 = center.lat / 180 * pi;
    final double lambda1 = center.lon / 180 * pi;
    final double tetha = bearing / 180 * pi;
    final double delta = distance / R;
    final double phi2 =
        asin(sin(phi1) * cos(delta) + cos(phi1) * sin(delta) * cos(tetha));
    final double lambda2 = lambda1 +
        atan2(sin(tetha) * sin(delta) * cos(phi1),
            cos(delta) - sin(phi1) * sin(phi2));
    return Location(lat: 180 * phi2 / pi, lon: 180 * lambda2 / pi);
  }
}
