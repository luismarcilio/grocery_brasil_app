import 'package:grocery_brasil_app/features/addressing/domain/Autocomplete.dart';

import '../../../domain/Address.dart';
import '../../../domain/Location.dart';

abstract class AddressingServiceAdapter {
  Future<Address> getAddressFromLocation(Location location);
  Future<List<Autocomplete>> getAutocomplete(String rawAddress);
  Future<Address> getAddressByPlaceId(String placeId);
}
