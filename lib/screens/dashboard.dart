import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/purchase/presentation/pages/ResumePurchaseList.dart';
import '../features/readNfFromSite/presentation/pages/ReadNfScreen.dart';
import '../features/scanQrCode/domain/QRCode.dart';
import '../features/scanQrCode/presentation/pages/qrcodeScreen.dart';
import 'SetupAccountScreen.dart';
import 'produtosScreen.dart';

class Dashboard extends StatefulWidget {
  static const route = '/dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  Map<int, Widget> scaffoldBodyMap = {
    0: ResumePurchaseList(),
    1: ProdutosScreen(),
    2: AccountSetupScreen()
  };

  Widget logout() {
    FirebaseAuth.instance.signOut();
    return Container(
      child: Text("logout"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suas Compras mais barato"),
      ),
      body: scaffoldBodyMap[selectedIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          QRCode qrcode = await Navigator.push<QRCode>(
              context, MaterialPageRoute(builder: (context) => QrCodeScreen()));
          print("qrcode: ${qrcode.url}");
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadNfScreen(
                url: qrcode.url,
              ),
            ),
          );
        },
        label: Text('Escanear nota'),
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            print(index);
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: 'Notas Fiscais'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_grocery_store), label: 'Produtos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity), label: 'Conta'),
        ],
        currentIndex: selectedIndex,
      ),
    );
  }
}
