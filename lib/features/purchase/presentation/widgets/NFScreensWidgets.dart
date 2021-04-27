import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/Purchase.dart';
import '../../../../domain/PurchaseItem.dart';

class NFScreensWidgets {
  final Purchase purchase;
  final BuildContext context;
  NFScreensWidgets({@required this.context, @required this.purchase});
  Hero resumoNfCard({Function onTap, Function onLongPress}) {
    print('date: ${purchase.fiscalNote}');
    return Hero(
      tag: purchase.fiscalNote.accessKey,
      child: new Card(
        child: Center(
          child: ListTile(
            leading: _moreItemsMenu(),
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

  Widget _moreItemsMenu() {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () async {
              // await Navigator.push<Share>(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Share(
              //       shareable: Shareable(
              //           content: 'Some text', format: ShareFormat.TEXT),
              //     ),
              //   ),
              // );
            },
            child: Icon(Icons.share),
          ),
        ),
        const PopupMenuItem(child: Icon(Icons.delete)),
      ],
    );
  }

  Card newnfItemCard(
      {PurchaseItem purchaseItem, Function onTap, Function onLongPress}) {
    return Card(
      child: Row(
        children: [
          _moreItemsMenu(),
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

  Card nfItemCard(
      {PurchaseItem purchaseItem, Function onTap, Function onLongPress}) {
    return Card(
      child: ListTile(
        leading: _moreItemsMenu(),
        title: new Text(purchaseItem.product.name),
        trailing: new Text("R\$ ${purchaseItem.totalValue.toString()}"),
        subtitle: new Text(
            "${purchaseItem.units.toString()} ${purchaseItem.unity.name} "),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  List<PopupMenuEntry<dynamic>> nfItemCardMenuItemBuilder(
    BuildContext context,
  ) {}
}
