import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/screens/loading.dart';

class AccountSetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Account'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: FirebaseAuth.instance.currentUser.getIdToken(true),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              final String jwt = snapshot.data.toString();
              final pattern =
                  RegExp('.{1,800}'); // 800 is the size of each chunk
              pattern.allMatches(jwt).forEach((match) => print(match.group(0)));
              return Text(snapshot.data.toString());
            },
          ),
          FlatButton(
              child: Text('Logoff'),
              onPressed: () => FirebaseAuth.instance.signOut()),
        ],
      ),
    );
  }
}
