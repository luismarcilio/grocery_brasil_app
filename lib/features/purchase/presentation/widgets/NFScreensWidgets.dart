import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/Purchase.dart';
import '../../../../domain/PurchaseItem.dart';

class NFScreensWidgets {
  static Hero resumoNfCard(
      {BuildContext context,
      Purchase purchase,
      Function onTap,
      Function onLongPress}) {
    print('date: ${purchase.fiscalNote}');
    return Hero(
      tag: purchase.fiscalNote.accessKey,
      child: new Card(
        child: Center(
          child: ListTile(
            leading: _moreItemsMenu(context),
            title: new Text(purchase.fiscalNote.company.name),
            trailing: new Text("R\$ ${purchase.totalAmount.toString()}"),
            subtitle: new Text(
                DateFormat('dd/MM/yyyy').format(purchase.fiscalNote.date)),
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        ),
      ),
    );
  }

  static Widget _moreItemsMenu(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(child: Icon(Icons.share)),
        const PopupMenuItem(child: Icon(Icons.delete)),
      ],
    );
  }

  static Card newnfItemCard(
      {BuildContext context,
      PurchaseItem purchaseItem,
      Function onTap,
      Function onLongPress}) {
    return Card(
      child: Row(
        children: [
          _moreItemsMenu(context),
          Expanded(
            child: ListTile(
              leading: purchaseItem.product.thumbnail == null
                  ? Icon(Icons.shopping_cart)
                  : Image.network(purchaseItem.product.thumbnail),
              title: new Text(purchaseItem.product.name),
              trailing: new Text("R\$ ${purchaseItem.totalValue.toString()}"),
              subtitle: new Text(
                  "${purchaseItem.units.toString()} ${purchaseItem.unity.name} "),
              onTap: onTap,
              onLongPress: onLongPress,
            ),
          ),
        ],
      ),
    );
  }

  static Card nfItemCard(
      {BuildContext context,
      PurchaseItem purchaseItem,
      Function onTap,
      Function onLongPress}) {
    return Card(
      child: ListTile(
        leading: _moreItemsMenu(context),
        title: new Text(purchaseItem.product.name),
        trailing: new Text("R\$ ${purchaseItem.totalValue.toString()}"),
        subtitle: new Text(
            "${purchaseItem.units.toString()} ${purchaseItem.unity.name} "),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
