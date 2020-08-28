import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/screens/initial_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          print('snapshot: $snapshot');
          if (snapshot.hasError) {
            throw snapshot.error;
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return InitialPage().loading;
          }
          return InitialPage();
        });
  }
}
