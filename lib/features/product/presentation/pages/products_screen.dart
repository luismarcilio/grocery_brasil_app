import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../domain/Address.dart';
import '../../../../domain/FiscalNote.dart';
import '../../../../domain/Product.dart';
import '../../../../domain/Unity.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [SearchTextForm(), Expanded(child: ResultsTable())],
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class SearchTextForm extends StatelessWidget {
  final Debouncer debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (text) => debouncer.run(() => print(text)),
        decoration: InputDecoration(
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
            hintText: 'Nome do produto',
            prefixIcon: Icon(Icons.local_grocery_store_rounded)),
        controller: controller,
      ),
    );
  }
}

class ResultsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Company> listCompany = List<Company>.from([
      Company(
        name: 'supermercado1',
        address: Address(
          rawAddress: '',
          street: 'Avenida da Saudade',
          number: '1110',
          county: 'Santa Marta',
          city: City(name: 'Uberaba'),
        ),
      ),
      Company(
        name: 'supermercado2',
        address: Address(
          rawAddress: '',
          street: 'Rua Novo Horizonte',
          number: '823',
          county: 'Mercês',
          city: City(name: 'Uberaba'),
        ),
      ),
      Company(
        name: 'supermercado3',
        address: Address(
          rawAddress: '',
          street: 'Rua dos Bobos',
          number: '0',
          county: 'Santa Maria',
          city: City(name: 'Uberaba'),
        ),
      ),
    ]);
    final product = Product(
        name: "Carne de vaca",
        thumbnail:
            'https://storage.googleapis.com/grocery-brasil-app-thumbnails/7896036090244',
        unity: Unity(name: 'UN'));
    return ListView(
      children: List<Widget>.of([
        ProductCard(
          company: listCompany[0],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 10.0,
        ),
        ProductCard(
          company: listCompany[1],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 11.0,
        ),
        ProductCard(
          company: listCompany[2],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 12.0,
        ),
        ProductCard(
          company: listCompany[0],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 10.0,
        ),
        ProductCard(
          company: listCompany[1],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 11.0,
        ),
        ProductCard(
          company: listCompany[2],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 12.0,
        ),
        ProductCard(
          company: listCompany[0],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 10.0,
        ),
        ProductCard(
          company: listCompany[1],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 11.0,
        ),
        ProductCard(
          company: listCompany[2],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 12.0,
        ),
        ProductCard(
          company: listCompany[0],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 10.0,
        ),
        ProductCard(
          company: listCompany[1],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 11.0,
        ),
        ProductCard(
          company: listCompany[2],
          product: product,
          purchaseDate: DateTime.now(),
          unityValue: 12.0,
        ),
      ]),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final DateTime purchaseDate;
  final double unityValue;
  final Company company;
  final Function onTap;
  final Function onLongPress;

  const ProductCard(
      {Key key,
      this.onTap,
      this.onLongPress,
      @required this.product,
      @required this.purchaseDate,
      @required this.unityValue,
      @required this.company})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          MoreItemsMenu(),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: product.thumbnail == null
                      ? Icon(Icons.shopping_cart)
                      : Image.network(product.thumbnail),
                  title: new Text(product.name),
                  trailing: new Text("R\$ ${unityValue.toString()}"),
                  subtitle: new Text("${product.unity.name} "),
                  onTap: onTap,
                  onLongPress: onLongPress,
                ),
                ListTile(
                    title: new Text(company.name),
                    subtitle: new Text(
                        "${company.address.street}, ${company.address.number}, ${company.address.county}, ${company.address.city.name}"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MoreItemsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(child: Icon(Icons.share)),
        const PopupMenuItem(child: Icon(Icons.delete)),
      ],
    );
  }
}
