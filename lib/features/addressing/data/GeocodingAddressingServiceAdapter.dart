import 'package:geocoding/geocoding.dart' show GeocodingPlatform;
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:meta/meta.dart';

import '../../../domain/Address.dart';
import '../../../domain/Location.dart';
import 'AddressingServiceAdapter.dart';

class GeocodingAddressingServiceAdapter implements AddressingServiceAdapter {
  final GeocodingPlatform geocodingPlatform;

  GeocodingAddressingServiceAdapter({@required this.geocodingPlatform});

  @override
  Future<Address> getAddressFromLocation(Location location) async {
    try {
      final placemarks = await geocodingPlatform.placemarkFromCoordinates(
          location.lat, location.lon);
      if (placemarks.isEmpty) {
        throw AddressingException(
            messageId: MessageIds.NOT_FOUND,
            message:
                'No addresses found on location(lat: ${location.lat}, lon: ${location.lon})');
      }
      final address = Address(
          rawAddress:
              '${placemarks[0].street} ${placemarks[0].name}, ${placemarks[0].subLocality}, CEP: ${placemarks[0].postalCode}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}',
          street: placemarks[0].street,
          number: placemarks[0].name,
          complement: '',
          poCode: placemarks[0].postalCode,
          county: placemarks[0].subLocality,
          country: Country(name: placemarks[0].country),
          state: State(name: placemarks[0].administrativeArea),
          city: City(name: placemarks[0].subAdministrativeArea),
          location: location);
      return address;
    } catch (e) {
      if (e is AddressingException) {
        throw e;
      }
      throw AddressingException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }
}
