import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareAdapterImpl.dart';
import 'package:grocery_brasil_app/features/share/domain/ShareFormat.dart';
import 'package:grocery_brasil_app/features/share/domain/Shareable.dart';
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
    test('Should call shareText', () async {
//setup
      Shareable input = Shareable(
          content: ShareableContent(text: 'SomeText', subject: 'someSubject'),
          format: ShareFormat.TEXT);
//act
      await sut.share(input);
//assert
      verify(mockFlutterShareStub.shareText(input));
    });

    test('Should call shareFile', () async {
//setup
      Shareable input = Shareable(
          content:
              ShareableContent(text: 'someFilePath', subject: 'someSubject'),
          format: ShareFormat.PDF);
//act
      await sut.share(input);
//assert
      verify(mockFlutterShareStub.shareFile(input));
    });
  });
}
