import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/services/authentication/userRepository.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Dashboard extends StatelessWidget {
  static const route = '/dashboard';
  static const url =
      'https://nfce.fazenda.mg.gov.br/portalnfce/sistema/qrcode.xhtml?p=31200819867464000128650170000243111100316095|2|1|1|AD873D0784198A32E0F158E04D63E21EF070EDFF';
  // static const url = 'https://google.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: WebView(
        debuggingEnabled: true,
        initialUrl: url,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) async {
            await Provider.of<UserRepository>(context, listen: false).logout();
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt), title: Text('Notas Fiscais')),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_grocery_store), title: Text('Produtos')),
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity), title: Text('Conta')),
          ]),
    );
  }
}
