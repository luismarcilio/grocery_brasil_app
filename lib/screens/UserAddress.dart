import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../services/LocationServices.dart';

class UserAddressScreen extends StatelessWidget {
  final String _currentAddress;

  UserAddressScreen(this._currentAddress);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =
        TextEditingController(text: _currentAddress);
    final TypeAheadField textField = TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          onEditingComplete: () {},
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.text,
          maxLines: null),
      suggestionsCallback: (pattern) async {
        if (pattern.length > 4) {
          return await getGeolocationAutocompleteSuggestion(pattern);
        }
        return Iterable.empty();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(Icons.location_on),
          title: Text(suggestion.description),
        );
      },
      onSuggestionSelected: (suggestion) {
        Navigator.pop(context, suggestion);
      },
    );

    return Container(
      child: SafeArea(child: Scaffold(body: textField)),
    );
  }
}
