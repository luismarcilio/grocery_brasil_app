import 'package:grocery_brasil_app/features/addressing/domain/Autocomplete.dart';

abstract class AddressAutocompleteService {
  Future<List<Autocomplete>> getAutocomplete(String rawAddress);
}
