import 'package:cloud_firestore/cloud_firestore.dart';

String host = "";
int port = 0;
String scheme = "";
String path = "";

Future<void> initializeApiConfiguration() async {
  if (host == "" || port == 0 || scheme == "" || path == "") {
    DocumentSnapshot configSnapshot = await FirebaseFirestore.instance
        .collection('apiConfiguration')
        .doc('v1')
        .get();
    host = configSnapshot.data()['host'];
    port = configSnapshot.data()['port'];
    scheme = configSnapshot.data()['scheme'];
    path = configSnapshot.data()['path'];
  }
}
