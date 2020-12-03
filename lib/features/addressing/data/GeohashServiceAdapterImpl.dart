import 'package:dart_geohash/dart_geohash.dart';
import 'package:meta/meta.dart';

import 'GeohashServiceAdapter.dart';

class GeohashServiceAdapterImpl implements GeohashServiceAdapter {
  final GeoHasher geoHasher;

  GeohashServiceAdapterImpl({@required this.geoHasher});

  @override
  List<double> decode(String geohash) {
    return geoHasher.decode(geohash);
  }

  @override
  String encode(double lat, double lon, {int precision: 9}) {
    return geoHasher.encode(lon, lat, precision: precision);
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
}
