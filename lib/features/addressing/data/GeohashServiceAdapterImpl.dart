import 'package:dart_geohash/dart_geohash.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:meta/meta.dart';
import 'package:proximity_hash/proximity_hash.dart' as proximity_hash;

import 'GeohashServiceAdapter.dart';

class GeohashServiceAdapterImpl implements GeohashServiceAdapter {
  final GeoHasher geoHasher;

  GeohashServiceAdapterImpl({@required this.geoHasher});

  @override
  List<double> decode(String geohash) {
    return geoHasher.decode(geohash);
  }

  @override
  String encode(Location location, {int precision: 9}) {
    return geoHasher.encode(location.lon, location.lat, precision: precision);
  }

  @override
  String findCommonGeohash(
      {String topLeft,
      String topRight,
      String bottomLeft,
      String bottomRight}) {
    final length = topLeft.length;
    assert(length == topRight.length);
    assert(length == bottomLeft.length);
    assert(length == bottomRight.length);
    int i = 0;
    do {
      final c = topLeft[i];
      if (c != topRight[i]) break;
      if (c != bottomLeft[i]) break;
      if (c != bottomLeft[i]) break;
      if (c != bottomRight[i]) break;
      i++;
    } while (true);

    return topLeft.substring(0, i);
  }

  @override
  List<String> createGeohashes(
      Location location, double radius, int precision) {
    return proximity_hash.createGeohashes(
        location.lat, location.lon, radius, precision);
  }

  @override
  bool inCircleCheck(Location location1, Location location2, double radius) {
    return proximity_hash.inCircleCheck(
        location1.lat, location1.lon, location2.lat, location2.lon, radius);
  }

  @override
  List<String> proximityGeohashes(Location location, double radius) {
    // Geohash precision
    //     #   km
    // 1   ± 2500
    // 2   ± 630
    // 3   ± 78
    // 4   ± 20
    // 5   ± 2.4
    // 6   ± 0.61
    // 7   ± 0.076

    int precision = 0;
    List<String> geohashesList;
    do {
      precision++;
      geohashesList = createGeohashes(location, radius, precision);
    } while (geohashesList.length < 10);
    return createGeohashes(location, radius, precision - 1);
  }
}
