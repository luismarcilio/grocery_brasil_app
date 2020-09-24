import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/screens/ScanNfScreen.dart';
import 'package:grocery_brasil_app/screens/produtosScreen.dart';

import 'SetupAccountScreen.dart';
import 'notasFiscaisScreen.dart';

class Dashboard extends StatefulWidget {
  static const route = '/dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  Map<int, Widget> scaffoldBodyMap = {
    0: NotasFiscaisScreen(),
    1: ProdutosScreen(),
    2: AccountSetupScreen()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: scaffoldBodyMap[selectedIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ScanNfScreen()));
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
