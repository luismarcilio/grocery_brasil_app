import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/Purchase.dart';
import '../../../../domain/PurchaseItem.dart';
import '../../../share/domain/Shareable.dart';
import '../../../share/domain/ShareableConverter.dart';
import '../../../share/presentation/pages/share.dart';

class NFScreensWidgets {
  final currencyNumberFormat = NumberFormat("###.00", "pt_BR");
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
            leading:
                _moreItemsMenu(itemBuilder: _resumoNfCardMenuItemBuilder()),
            title: new Text(purchase.fiscalNote.company.name),
            trailing: new Text(
                "R\$ ${currencyNumberFormat.format(purchase.totalAmount)}"),
            subtitle: new Text(
                DateFormat('dd/MM/yyyy').format(purchase.fiscalNote.date)),
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        ),
      ),
    );
  }

  Widget _moreItemsMenu({@required List<PopupMenuEntry<dynamic>> itemBuilder}) {
    return PopupMenuButton(
      itemBuilder: (context) => itemBuilder,
    );
  }

  Card newnfItemCard(
      {PurchaseItem purchaseItem, Function onTap, Function onLongPress}) {
    return Card(
      child: Row(
        children: [
          _moreItemsMenu(
              itemBuilder:
                  _nfItemCardMenuItemBuilder(purchaseItem: purchaseItem)),
          Expanded(
            child: ListTile(
              leading: purchaseItem.product.thumbnail == null
                  ? Icon(Icons.shopping_cart)
                  : Image.network(purchaseItem.product.thumbnail),
              title: new Text(purchaseItem.product.name),
              trailing: new Text(
                  "R\$ ${currencyNumberFormat.format(purchaseItem.totalValue)}"),
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
        leading: _moreItemsMenu(
            itemBuilder:
                _nfItemCardMenuItemBuilder(purchaseItem: purchaseItem)),
        title: new Text(purchaseItem.product.name),
        trailing: new Text(
            "R\$ ${currencyNumberFormat.format(purchaseItem.totalValue)}"),
        subtitle: new Text(
            "${purchaseItem.units.toString()} ${purchaseItem.unity.name} "),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  List<PopupMenuEntry<dynamic>> _resumoNfCardMenuItemBuilder() {
    return [
      PopupMenuItem(
        child: Icon(Icons.delete),
      ),
    ];
  }

  List<PopupMenuEntry<dynamic>> _nfItemCardMenuItemBuilder(
      {@required PurchaseItem purchaseItem}) {
    return [
      PopupMenuItem(
        child: _shareButton(purchaseItem: purchaseItem),
      ),
    ];
  }

  TextButton _shareButton({@required PurchaseItem purchaseItem}) {
    PurchaseItemConverterInput purchaseItemConverterInput =
        PurchaseItemConverterInput(
            purchaseItem: purchaseItem, company: purchase.fiscalNote.company);
    ShareableConverter converter = PurchaseItemConverter();
    Shareable shareable = converter.convert(purchaseItemConverterInput);
    return TextButton(
      onPressed: () async {
        await Navigator.push<Share>(
          context,
          MaterialPageRoute(
            builder: (context) => Share(
              shareable: shareable,
            ),
          ),
        );
      },
      child: Icon(Icons.share),
    );
  }
}
