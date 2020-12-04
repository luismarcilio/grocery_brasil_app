import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/addressing/data/GeohashServiceAdapter.dart';
import 'package:grocery_brasil_app/features/addressing/data/GeohashServiceAdapterImpl.dart';
import 'package:mockito/mockito.dart';

class MockGeoHasher extends Mock implements GeoHasher {}

main() {
  MockGeoHasher mockGeoHasher;
  GeohashServiceAdapter sut;
  group('GeohashServiceAdapterImpl', () {
    setUp(() {
      mockGeoHasher = MockGeoHasher();
      sut = GeohashServiceAdapterImpl(geoHasher: mockGeoHasher);
    });

    test('should when ', () {
      //setup
      const topLeft = 'geohashTopLeft';
      const topRight = 'geohashTopRigh';
      const bottomRight = 'geohashBotRigh';
      const bottomLeft = 'geohashBotLeft';
      const expected = 'geohash';

      //act
      final actual = sut.findCommonGeohash(
          topLeft: topLeft,
          topRight: topRight,
          bottomRight: bottomRight,
          bottomLeft: bottomLeft);
      //assert
      expect(actual, expected);
    });
  });
}
