import 'package:grocery_brasil_app/domain/Location.dart';

abstract class GPSServiceAdapter {
  Future<Location> getCurrentLocation();
}
