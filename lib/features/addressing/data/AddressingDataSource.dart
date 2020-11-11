import '../../../domain/Address.dart';

abstract class AddressingDataSource {
  Future<Address> getCurrentAddress();
}
