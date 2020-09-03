import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'notasFiscaisScreen.dart';

class Dashboard extends StatefulWidget {
  static const route = '/dashboard';
//  static const url =
//      'http://192.168.0.111:8080/portalnfce/sistema/qrcode.xhtml?p=31200819867464000128650170000243111100316095|2|1|1|AD873D0784198A32E0F158E04D63E21EF070EDFF';
  static const url =
      'http://192.168.0.111:8080/portalnfce/sistema/qrcode.xhtml?p=31200819867464000128650110000249791100285123|2|1|1|AB75AA53F822C8F99011C152BA4BD0643A3317A1';
//  static const url =
//      'http://192.168.0.111:8080/portalnfce/sistema/qrcode.xhtml?p=31200906626253106570650060000367101000020581|2|1|1|8075450cf9f1108409912e3a4a6f44910fc15fb0';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  Widget webView(BuildContext context, AsyncSnapshot<String> _jwt) {
    if (_jwt.connectionState == ConnectionState.waiting) {
      return Text('Loading');
    }
    Uri uri = Uri.parse(Dashboard.url);
    Map<String, List<String>> queryParameters =
        Map.from(uri.queryParametersAll);
    queryParameters.addAll({
      'jwt': [_jwt.data]
    });

    Uri newUri = Uri(
        scheme: uri.scheme,
        userInfo: uri.userInfo,
        host: uri.host,
        port: uri.port,
        path: uri.path,
        queryParameters: queryParameters);

    return WebView(
      debuggingEnabled: true,
      initialUrl: newUri.toString(),
      javascriptMode: JavascriptMode.unrestricted,
      gestureNavigationEnabled: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: NotasFiscaisScreen(),
//      FutureBuilder<String>(
//        future: FirebaseAuth.instance.currentUser.getIdToken(true),
//        builder: webView,
//      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            print(index);
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), title: Text('Notas Fiscais')),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_grocery_store), title: Text('Produtos')),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity), title: Text('Conta')),
        ],
        currentIndex: selectedIndex,
      ),
    );
  }
}
