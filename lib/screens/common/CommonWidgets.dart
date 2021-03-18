import 'dart:math';

import 'package:flutter/material.dart';

class ApplicationFormField extends StatelessWidget {
  final String hint;
  final String labelText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function validator;
  final Function onTap;

  ApplicationFormField(
      {@required this.controller,
      this.hint = '',
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onTap,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          helperMaxLines: null,
          hintText: hint,
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboardType,
        maxLines: null,
        controller: controller,
        validator: validator,
        onTap: onTap,
      ),
    );
  }
}

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

class AppSlider extends StatefulWidget {
  final Function onChangeEnd;
  final double initialValue;
  AppSlider({this.onChangeEnd, this.initialValue});

  @override
  _AppSliderState createState() =>
      _AppSliderState(this.onChangeEnd, this.initialValue);
}

class _AppSliderState extends State<AppSlider> {
  final double initialValue;
  double currentValue;
  final Function onChangeEnd;
  _AppSliderState(this.onChangeEnd, this.initialValue);
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
