import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../domain/Purchase.dart';
import '../../../../domain/PurchaseItem.dart';
import '../../../share/domain/Shareable.dart';
import '../../../share/domain/ShareableConverter.dart';
import '../../../share/presentation/pages/share.dart';
import '../bloc/purchase_bloc.dart';

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
            leading: _moreItemsMenu(
                itemBuilder: _resumoNfCardMenuItemBuilder(),
                itemAction: _resumoNfCardMenuItemAction()),
            title: new Text(purchase.fiscalNote.company.name),
            trailing: _priceTag(
                amount: purchase.totalAmount, discount: purchase.totalDiscount),
            subtitle: new Text(
                DateFormat('dd/MM/yyyy').format(purchase.fiscalNote.date)),
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        ),
      ),
    );
  }

  Hero appbarTitle({Function onTap, Function onLongPress}) {
    print('date: ${purchase.fiscalNote}');
    return Hero(
      tag: purchase.fiscalNote.accessKey,
      child: new Card(
        child: Center(
          child: ListTile(
            title: Text(purchase.fiscalNote.company.name.length > 20
                ? purchase.fiscalNote.company.name.substring(0, 20) + '...'
                : purchase.fiscalNote.company.name),
            trailing: _priceTag(
                amount: purchase.totalAmount, discount: purchase.totalDiscount),
            subtitle: new Text(
                DateFormat('dd/MM/yyyy').format(purchase.fiscalNote.date)),
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        ),
      ),
    );
  }

  Widget _moreItemsMenu(
      {@required List<PopupMenuEntry<dynamic>> itemBuilder,
      @required List<Function> itemAction}) {
    assert(itemBuilder.length == itemAction.length);
    return PopupMenuButton(
      enableFeedback: true,
      onSelected: (item) => itemAction[item](),
      itemBuilder: (context) => itemBuilder,
    );
  }

  Card newnfItemCard(
      {PurchaseItem purchaseItem, Function onTap, Function onLongPress}) {
    final unitsNumberFormat = NumberFormat("###,###,###.###", "pt_BR");

    return Card(
      child: Row(
        children: [
          _moreItemsMenu(
              itemBuilder: _nfItemCardMenuItemBuilder(),
              itemAction:
                  _nfItemCardMenuItemAction(purchaseItem: purchaseItem)),
          Expanded(
            child: ListTile(
              leading: purchaseItem.product.thumbnail == null
                  ? Icon(Icons.shopping_cart)
                  : Image.network(purchaseItem.product.thumbnail),
              title: new Text(purchaseItem.product.name),
              trailing: _priceTag(
                  amount: purchaseItem.totalValue,
                  discount: purchaseItem.discount),
              subtitle: new Text(
                  "${unitsNumberFormat.format(purchaseItem.units)} ${purchaseItem.unity.name} "),
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
    final unitsNumberFormat = NumberFormat("###,###,###.###", "pt_BR");

    return Card(
      child: ListTile(
        leading: _moreItemsMenu(
            itemBuilder: _nfItemCardMenuItemBuilder(),
            itemAction: _nfItemCardMenuItemAction(purchaseItem: purchaseItem)),
        title: new Text(purchaseItem.product.name),
        trailing: _priceTag(
            amount: purchaseItem.totalValue, discount: purchaseItem.discount),
        subtitle: new Text(
            "${unitsNumberFormat.format(purchaseItem.units)} ${purchaseItem.unity.name} "),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  List<PopupMenuEntry<dynamic>> _resumoNfCardMenuItemBuilder() {
    return [PopupMenuItem(value: 0, child: Icon(Icons.delete))];
  }

  List<Function> _resumoNfCardMenuItemAction() {
    return [
      () async {
        final response = await _showMyDialog();
        if (response) {
          BlocProvider.of<PurchaseBloc>(context).add(
              DeletePurchaseEvent(purchaseId: purchase.fiscalNote.accessKey));
        }
      }
    ];
  }

  List<PopupMenuEntry<dynamic>> _nfItemCardMenuItemBuilder() {
    return [PopupMenuItem(value: 0, child: Icon(Icons.share))];
  }

  List<Function> _nfItemCardMenuItemAction(
      {@required PurchaseItem purchaseItem}) {
    return [
      () async {
        PurchaseItemConverterInput purchaseItemConverterInput =
            PurchaseItemConverterInput(
                purchaseItem: purchaseItem,
                company: purchase.fiscalNote.company);
        ShareableConverter converter = PurchaseItemConverter();
        Shareable shareable = converter.convert(purchaseItemConverterInput);
        await Navigator.push<Share>(
          context,
          MaterialPageRoute(
            builder: (context) => Share(
              shareable: shareable,
            ),
          ),
        );
      }
    ];
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text('Tem certeza que quer deletar a compra?'),
          actions: <Widget>[
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Column _priceTag({@required double amount, @required double discount}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        new Text(
          "R\$ ${currencyNumberFormat.format(amount)}",
          style: TextStyle(color: Colors.indigo[900]),
        ),
        if (discount != null && discount != 0)
          Text(
            "Desc: R\$ ${currencyNumberFormat.format(discount)}",
            style: TextStyle(color: Colors.red[900]),
          ),
      ],
    );
  }
}
