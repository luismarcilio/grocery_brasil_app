import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Card nfItemCard({dynamic purchaseItem, Function onTap, Function onLongPress}) {
  return Card(
    child: ListTile(
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
