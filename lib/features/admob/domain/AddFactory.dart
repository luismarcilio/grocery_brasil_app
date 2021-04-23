import 'package:flutter/material.dart';

abstract class AddFactory<T extends Widget> {
  T get();
}
