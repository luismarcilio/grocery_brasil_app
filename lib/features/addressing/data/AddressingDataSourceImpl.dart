import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:meta/meta.dart';

import '../../../domain/Address.dart';
import 'AddressingDataSource.dart';
import 'AddressingServiceAdapter.dart';
import 'GPSServiceAdapter.dart';

class AddressingDataSourceImpl implements AddressingDataSource {
  final GPSServiceAdapter gPSServiceAdapter;
  final AddressingServiceAdapter addressingServiceAdapter;

  AddressingDataSourceImpl(
      {@required this.gPSServiceAdapter,
      @required this.addressingServiceAdapter});

  @override
  Future<Address> getCurrentAddress() async {
    try {
      final location = await gPSServiceAdapter.getCurrentLocation();
      final address =
          await addressingServiceAdapter.getAddressFromLocation(location);
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
