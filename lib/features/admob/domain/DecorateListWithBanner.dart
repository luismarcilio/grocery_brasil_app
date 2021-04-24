import 'package:flutter/material.dart';
import 'package:grocery_brasil_app/features/admob/domain/DecorateListWithAds.dart';
import 'package:grocery_brasil_app/features/admob/widgets/BannerInline.dart';

class DecorateHeroListWithBanner
    implements DecorateListWithAds<Hero, BannerAdd> {
  @override
  List<Hero> decorate(
      List<Hero> original, BannerAdd addFactory, int frequency) {
    for (int i = frequency; i < original.length; i += frequency) {
      original.insert(
        i++,
        Hero(
          tag: 'add',
          child: addFactory.get(),
        ),
      );
    }
    original.add(
      Hero(
        tag: 'add',
        child: addFactory.get(),
      ),
    );
    return original;
  }
}

class DecorateWidgetListWithBanner
    implements DecorateListWithAds<Widget, BannerAdd> {
  @override
  List<Widget> decorate(
      List<Widget> original, BannerAdd addFactory, int frequency) {
    for (int i = frequency; i < original.length; i += frequency) {
      original.insert(i++, Container(child: addFactory.get()));
    }
    original.add(Container(child: addFactory.get()));
    return original;
  }
}
