import 'package:flutter/material.dart';

class TextRaisedButton extends StatelessWidget {
  final Function onPressed;
  final Function onLongPress;
  final String label;
  TextRaisedButton({this.label, this.onPressed, this.onLongPress});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: RaisedButton(
        child: Text(label),
        onPressed: onPressed,
        onLongPress: onLongPress,
      ),
    );
  }
}
