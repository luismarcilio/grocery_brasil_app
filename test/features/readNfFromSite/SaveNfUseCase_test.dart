import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/features/purchase/domain/PurchaseRepository.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/SaveNfUseCase.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NfHtmlFromSite.dart';
import 'package:mockito/mockito.dart';

class MockPurchaseRepository extends Mock implements PurchaseRepository {}

main() {
  SaveNfUseCase saveNfUseCase;
  MockPurchaseRepository mockPurchaseRepository;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    saveNfUseCase = SaveNfUseCase(purchaseRepository: mockPurchaseRepository);
  });

  group('SaveNfUseCase', () {
    test('should when ', () async {
      //setup
      final nfHtmlFromSite = NfHtmlFromSite(html: "html", uf: "MG");
      when(mockPurchaseRepository.save(nfHtmlFromSite: nfHtmlFromSite))
          .thenAnswer((realInvocation) async => Right(nfHtmlFromSite));
      //act
      final actual =
          await saveNfUseCase(Params(nfHtmlFromSite: nfHtmlFromSite));
      //assert
      expect(actual, Right(nfHtmlFromSite));
    });
  });
}
