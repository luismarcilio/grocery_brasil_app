import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../domain/Address.dart';
import '../../../addressing/data/AddressingServiceAdapter.dart';
import '../../../addressing/domain/Autocomplete.dart';

class UserAddressScreen extends StatelessWidget {
  final AddressingServiceAdapter addressingServiceAdapter;
  final String initialAddress;

  const UserAddressScreen(
      {Key key,
      @required this.addressingServiceAdapter,
      @required this.initialAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =
        TextEditingController(text: initialAddress);
    final TypeAheadField textField = TypeAheadField<Autocomplete>(
      textFieldConfiguration: TextFieldConfiguration(
          onEditingComplete: () {},
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.text,
          maxLines: null),
      suggestionsCallback: (pattern) async {
        if (pattern.length > 4) {
          return await addressingServiceAdapter.getAutocomplete(pattern);
        }
        return Iterable.empty();
      },
      itemBuilder: (BuildContext context, suggestion) {
        return ListTile(
          leading: Icon(Icons.location_on),
          title: Text(suggestion.description),
        );
      },
      onSuggestionSelected: (Autocomplete suggestion) async {
        Address address = await addressingServiceAdapter
            .getAddressByPlaceId(suggestion.placeId);
        Navigator.pop(context, address);
      },
    );

    return Container(
      child: SafeArea(child: Scaffold(body: textField)),
    );
  }
}
