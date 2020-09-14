import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_brasil_app/services/ProductsRepository.dart';

Widget _getThumbnail(dynamic purchaseItem) {
  return FutureBuilder(
    future: getThumbnailUrl(purchaseItem['product']),
    builder: (context, AsyncSnapshot<String> snapshot) {
      if (!snapshot.hasData) {
        return SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.hasError) {
        print('SNAPSHOT ERROR: ${snapshot.error}');
      }
      String thumbnailUrl = snapshot.data;
      Widget _thumbnail;
      if (thumbnailUrl == '') {
        return Icon(Icons.shopping_cart);
      }
      try {
        _thumbnail = Image.network(thumbnailUrl);
      } catch (e) {
        _thumbnail = Icon(Icons.shopping_cart);
      }
      return _thumbnail;
    },
  );
}

Card nfItemCard({dynamic purchaseItem, Function onTap, Function onLongPress}) {
  return Card(
    child: ListTile(
      leading: _getThumbnail(purchaseItem),
      title: new Text(
        purchaseItem['product']['name'],
      ),
      trailing: new Text("R\$ ${purchaseItem['totalValue'].toString()}"),
      subtitle: new Text(
          "${purchaseItem['units'].toString()} ${purchaseItem['unity']['name']} "),
      onTap: onTap,
      onLongPress: onLongPress,
    ),
  );
}
