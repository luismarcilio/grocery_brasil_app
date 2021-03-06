import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/usecases/usecase.dart';
import '../features/login/domain/usecases/Logout.dart';
import '../features/login/presentation/pages/login.dart';
import '../features/product/presentation/pages/products_screen.dart';
import '../features/purchase/presentation/pages/ResumePurchaseList.dart';
import '../features/readNfFromSite/presentation/pages/ReadNfScreen.dart';
import '../features/scanQrCode/domain/QRCode.dart';
import '../features/scanQrCode/presentation/pages/qrcodeScreen.dart';
import '../features/user/presentation/screen/SetupAccountScreen.dart';
import '../injection_container.dart';

class Dashboard extends StatefulWidget {
  static const route = '/dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  Logout logout = sl();
  Map<int, Widget> scaffoldBodyMap = {
    0: ResumePurchaseList(),
    1: ProductsScreen(),
    2: AccountSetupScreen()
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Suas Compras mais barato"),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    logout(NoParams());
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  child: Icon(
                    FontAwesomeIcons.signOutAlt,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
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
        icon: Icon(FontAwesomeIcons.qrcode),
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
