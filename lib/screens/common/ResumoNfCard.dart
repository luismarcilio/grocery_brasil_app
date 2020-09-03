import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils.dart';

Hero resumoNfCard(
    {DocumentSnapshot document, Function onTap, Function onLongPress}) {
  return Hero(
    tag: document.id,
    child: new Card(
      child: ListTile(
        title: new Text(document.data()['company']['name']),
        trailing: new Text("R\$ ${document.data()['totalAmount'].toString()}"),
        subtitle: new Text(formatDate(DateTime.parse(document.data()['date']))),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    ),
  );
}
