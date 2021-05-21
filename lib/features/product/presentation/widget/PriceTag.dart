import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

Column priceTag({@required double amount, @required double discount}) {
  final currencyNumberFormat = NumberFormat("###.00", "pt_BR");
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      new Text(
        "R\$ ${currencyNumberFormat.format(amount)}",
        style: TextStyle(color: Colors.indigo[900], fontSize: 12),
      ),
      if (discount != null && discount != 0)
        Text(
          "Desc: R\$ ${currencyNumberFormat.format(discount)}",
          style: TextStyle(color: Colors.red[900], fontSize: 12),
        ),
    ],
  );
}
