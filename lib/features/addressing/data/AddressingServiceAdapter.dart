import '../../../domain/Address.dart';
import '../../../domain/Location.dart';

abstract class AddressingServiceAdapter {
  Future<Address> getAddressFromLocation(Location location);
}
