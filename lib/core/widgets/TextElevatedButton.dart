import 'package:flutter/material.dart';

class TextElevatedButton extends StatelessWidget {
  final Function onPressed;
  final Function onLongPress;
  final String label;
  TextElevatedButton({this.label, this.onPressed, this.onLongPress});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        child: Text(label),
        onPressed: onPressed,
        onLongPress: onLongPress,
      ),
    );
  }
}
