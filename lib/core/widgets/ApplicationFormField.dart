import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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
