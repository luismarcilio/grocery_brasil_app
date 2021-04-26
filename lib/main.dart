import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'features/initialize_firebase/presentation/pages/initialize_firebase.dart';
import 'injection_container.dart' as di;

void main() async {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu supermercado mais barato',
      home: InitialiseFirebase(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
      ],
    );
  }
}
