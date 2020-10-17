import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Purchase.dart';
import 'package:grocery_brasil_app/features/common/domain/PurchaseRepository.dart';
import 'package:grocery_brasil_app/features/purchase/domain/ListPurchasesUseCase.dart';
import 'package:mockito/mockito.dart';

class MockPurchaseRepository extends Mock implements PurchaseRepository {}

main() {
  MockPurchaseRepository mockPurchaseRepository;
  ListPurchasesUseCase listPurchasesUseCase;

  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    listPurchasesUseCase =
        ListPurchasesUseCase(repository: mockPurchaseRepository);
  });

  group('ListPurchasesUseCase', () {
    test('should list the purchases', () async {
      //setup
      final expected = Stream<List<Purchase>>.fromIterable([
        List<Purchase>.from([Purchase()])
      ]);
      when(mockPurchaseRepository.listPurchaseResume())
          .thenAnswer((realInvocation) async => Right(expected));
      //act
      final Either<Failure, Stream<List<Purchase>>> actual =
          await listPurchasesUseCase(NoParams());
      //assert
      expect(actual, Right(expected));
    });
  });
}
