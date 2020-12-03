abstract class GeohashServiceAdapter {
  String encode(double lat, double lon, {int precision});
  List<double> decode(String geohash);
  String findCommonGeohash(
      {String topLeft, String topRight, String bottomLeft, String bottomRight});
}
