import '../../../domain/Address.dart';
import '../../../domain/Location.dart';
import '../domain/Autocomplete.dart';

abstract class AddressingServiceAdapter {
  Future<Address> getAddressFromLocation(Location location);
  Future<List<Autocomplete>> getAutocomplete(String rawAddress);
  Future<Address> getAddressByPlaceId(String placeId);
}
