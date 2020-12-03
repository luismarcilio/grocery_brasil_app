import 'package:meta/meta.dart';

import '../../../domain/Location.dart';

abstract class GPSServiceAdapter {
  Future<Location> getCurrentLocation();
  double distanceBetween({@required Location start, @required Location end});
  List<Location> calculateTopLeftBottomRight({Location center, int distance});
}
