import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:grocery_brasil_app/services/LocationServices.dart';
import 'package:grocery_brasil_app/services/UserRepository.dart';

class AccountSetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    final _controller = NativeAdmobController();
    final _adUnitID = 'ca-app-pub-3940256099942544/8135179316';

    final TypeAheadField textField = TypeAheadField<GeolocationSuggestion>(
      textFieldConfiguration:
          TextFieldConfiguration(controller: textEditingController),
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
        textEditingController.text = suggestion.description;
        getPositionByPlaceId(suggestion.placeId).then((address) {
          saveUserAddress(address);
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Account'),
      ),
      body: ListView(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: NativeAdmob(
              // Your ad unit id
              adUnitID: _adUnitID,
              numberAds: 1,
              controller: _controller,
              type: NativeAdmobType.full,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: NativeAdmob(
              // Your ad unit id
              adUnitID: _adUnitID,
              numberAds: 2,
              controller: _controller,
              type: NativeAdmobType.banner,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: NativeAdmob(
              // Your ad unit id
              adUnitID: _adUnitID,
              numberAds: 3,
              controller: _controller,
              type: NativeAdmobType.full,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: NativeAdmob(
              // Your ad unit id
              adUnitID: _adUnitID,
              numberAds: 4,
              controller: _controller,
              type: NativeAdmobType.banner,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: NativeAdmob(
              // Your ad unit id
              adUnitID: _adUnitID,
              numberAds: 5,
              controller: _controller,
              type: NativeAdmobType.full,
            ),
          ),
        ],
      ),
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
