import 'package:flutter/material.dart';

import 'AddFactory.dart';

abstract class DecorateListWithAds<L extends Widget, A extends AddFactory> {
  List<L> decorate(List<L> original, A addFactory, int frequency);
}
