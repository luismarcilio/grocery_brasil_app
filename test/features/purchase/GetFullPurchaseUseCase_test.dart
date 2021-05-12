import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Purchase.dart';
import 'package:grocery_brasil_app/features/purchase/domain/PurchaseRepository.dart';
import 'package:grocery_brasil_app/features/purchase/domain/GetFullPurchaseUseCase.dart';
import 'package:mockito/mockito.dart';

class MockPurchaseRepository extends Mock implements PurchaseRepository {}

main() {
  MockPurchaseRepository mockPurchaseRepository;
  GetFullPurchaseUseCase getFullPurchaseUseCase;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    getFullPurchaseUseCase =
        GetFullPurchaseUseCase(repository: mockPurchaseRepository);
  });

  group('GetFullPurchaseUseCase', () {
    test('should get the purchase', () async {
      //setup
      final expected = Purchase();
      when(mockPurchaseRepository.getPurchaseById(purchaseId: "purchaseId"))
          .thenAnswer((realInvocation) async => Right(expected));
      //act
      final Either<Failure, Purchase> actual =
          await getFullPurchaseUseCase(Params(purchaseId: "purchaseId"));
      //assert
      expect(actual, Right(expected));
    });
  });
}
