import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareAdapterImpl.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:mockito/mockito.dart';

class MockFlutterShareStub extends Mock implements FlutterShareStub {}

main() {
  MockFlutterShareStub mockFlutterShareStub;
  ShareAdapterImpl sut;

  setUp(() {
    mockFlutterShareStub = MockFlutterShareStub();
    sut = ShareAdapterImpl(flutterShareStub: mockFlutterShareStub);
  });
  group('ShareAdapterImpl', () {
    test('Should call share', () async {
//setup
      String textToShare = 'Some text';
//act
      await sut.share(textToShare, ShareFormat.TEXT);
//assert
      verify(mockFlutterShareStub.share(textToShare));
    });
  });
}
