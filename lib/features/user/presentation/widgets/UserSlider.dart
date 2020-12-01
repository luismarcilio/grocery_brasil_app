import 'dart:math';
import 'package:flutter/material.dart';

class UserSlider extends StatefulWidget {
  final Function onChangeEnd;
  final double initialValue;
  UserSlider({this.onChangeEnd, this.initialValue});

  @override
  _UserSliderState createState() =>
      _UserSliderState(this.onChangeEnd, this.initialValue);
}

class _UserSliderState extends State<UserSlider> {
  final double initialValue;
  double currentValue;
  final Function onChangeEnd;
  _UserSliderState(this.onChangeEnd, this.initialValue);
  String getLabel() {
    double _doubleLable = pow(10, currentValue);
    return _doubleLable < 10000
        ? '${_doubleLable.toInt()} m'
        : '${(_doubleLable ~/ 1000)} Km';
  }

  @override
  Widget build(BuildContext context) {
    currentValue ??= initialValue;
    return Slider(
      min: 2.0,
      max: 6.0,
      label: getLabel(),
      divisions: 100,
      value: currentValue,
      onChangeEnd: onChangeEnd,
      onChanged: (_newValue) {
        setState(() {
          currentValue = _newValue;
        });
      },
    );
  }
}
