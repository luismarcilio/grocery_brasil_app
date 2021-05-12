import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/features/purchase/domain/PurchaseRepository.dart';
import 'package:grocery_brasil_app/features/purchase/domain/DeletePurchaseUseCase.dart';
import 'package:mockito/mockito.dart';

class MockPurchaseRepository extends Mock implements PurchaseRepository {}

main() {
  MockPurchaseRepository mockPurchaseRepository;
  DeletePurchaseUseCase sut;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    sut = DeletePurchaseUseCase(repository: mockPurchaseRepository);
  });

  group('GetFullPurchaseUseCase', () {
    test('should get the purchase', () async {
      //setup
      when(mockPurchaseRepository.deletePurchase(purchaseId: "purchaseId"))
          .thenAnswer((realInvocation) async => Right(null));
      //act
      final Either<Failure, void> actual =
          await sut(Params(purchaseId: "purchaseId"));
      //assert
      expect(actual, Right(null));
      verify(mockPurchaseRepository.deletePurchase(purchaseId: "purchaseId"))
          .called(1);
    });
  });
}
