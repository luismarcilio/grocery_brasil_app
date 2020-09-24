import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:grocery_brasil_app/services/LocationServices.dart';

class AccountSetupScreen extends StatelessWidget {
  final TypeAheadField textField = TypeAheadField<GeolocationSuggestion>(
    suggestionsCallback: (location) async {
      if (location.length > 5) {
        print('location: $location');
        return await getGeolocationAutocompleteSuggestion(location);
      }
      return Iterable.empty();
    },
    itemBuilder: (context, suggestion) {
      return ListTile(
        leading: Icon(Icons.home),
        title: Text(suggestion.description),
      );
    },
    onSuggestionSelected: (suggestion) {
      print('Selected: $suggestion');
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Account'),
      ),
      body: textField,
//      body: Column(
//        children: [
//          textField,
//          FutureBuilder(
//            future: FirebaseAuth.instance.currentUser.getIdToken(true),
//            builder: (context, snapshot) {
//              if (!snapshot.hasData) {
//                return Loading();
//              }
//              final String jwt = snapshot.data.toString();
//              final pattern =
//                  RegExp('.{1,800}'); // 800 is the size of each chunk
//              pattern.allMatches(jwt).forEach((match) => print(match.group(0)));
//              return Text(snapshot.data.toString());
//            },
//          ),
//          FlatButton(
//              child: Text('Logoff'),
//              onPressed: () => FirebaseAuth.instance.signOut()),
//        ],
//      ),
    );
  }
}
