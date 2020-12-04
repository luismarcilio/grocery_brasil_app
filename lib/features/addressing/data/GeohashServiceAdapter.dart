import '../../../domain/Location.dart';

abstract class GeohashServiceAdapter {
  String encode(Location location, {int precision});
  List<double> decode(String geohash);
  String findCommonGeohash(
      {String topLeft, String topRight, String bottomLeft, String bottomRight});

  List<String> createGeohashes(Location location, double radius, int precision);
  bool inCircleCheck(Location location1, Location location2, double radius);

  List<String> proximityGeohashes(Location location, double radius);
}
