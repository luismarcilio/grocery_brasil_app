import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/admob/domain/DecorateHeroListWithBanner.dart';
import 'package:grocery_brasil_app/features/admob/widgets/BannerInline.dart';

main() {
  DecorateHeroListWithBanner sut;
  setUp(() {
    sut = new DecorateHeroListWithBanner();
  });
  group('DecorateHeroListWithBanner', () {
    test('should insert the banner in the right places', () {
      final List<Hero> heroList = List.of([
        Hero(tag: 'hero1', child: Container()),
        Hero(tag: 'hero2', child: Container()),
        Hero(tag: 'hero3', child: Container()),
        Hero(tag: 'hero4', child: Container()),
        Hero(tag: 'hero5', child: Container()),
        Hero(tag: 'hero6', child: Container()),
        Hero(tag: 'hero7', child: Container()),
        Hero(tag: 'hero8', child: Container())
      ]);
      final int frequency = 3;
      final List<Hero> expected = List.of([
        Hero(tag: 'hero1', child: Container()),
        Hero(tag: 'hero2', child: Container()),
        Hero(tag: 'hero3', child: Container()),
        Hero(tag: 'add', child: Container(child: BannerInline())),
        Hero(tag: 'hero4', child: Container()),
        Hero(tag: 'hero5', child: Container()),
        Hero(tag: 'hero6', child: Container()),
        Hero(tag: 'add', child: Container(child: BannerInline())),
        Hero(tag: 'hero7', child: Container()),
        Hero(tag: 'hero8', child: Container()),
        Hero(tag: 'add', child: Container(child: BannerInline())),
      ]);

      final actual = sut.decorate(heroList, BannerAdd(), frequency);
      expect(actual.length, equals(expected.length));
    });
  });
}
