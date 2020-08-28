import 'package:flutter/material.dart';

Future<void> dialog(
    {@required BuildContext context,
    @required String title,
    @required String text,
    List<MaterialButton> actions}) {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: actions,
        );
      });
}

// Widget dialog({String title, String text, List<MaterialButton> actions}) {
//   return AlertDialog(
//     title: Text(title),
//     content: Text(text),
//     actions: actions,
//   );
// }
