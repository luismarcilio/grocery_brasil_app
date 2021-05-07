import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Purchase.dart';
import 'package:grocery_brasil_app/features/purchase/domain/DeletePurchaseUseCase.dart'
    as deletePurchase;
import 'package:grocery_brasil_app/features/purchase/domain/GetFullPurchaseUseCase.dart';
import 'package:grocery_brasil_app/features/purchase/domain/ListPurchasesUseCase.dart';
import 'package:grocery_brasil_app/features/purchase/presentation/bloc/purchase_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

class MockListPurchasesUseCase extends Mock implements ListPurchasesUseCase {}

class MockGetFullPurchaseUseCase extends Mock
    implements GetFullPurchaseUseCase {}

class MockDeletePurchaseUseCase extends Mock
    implements deletePurchase.DeletePurchaseUseCase {}

main() {
  MockListPurchasesUseCase mockListPurchasesUseCase =
      MockListPurchasesUseCase();
  MockGetFullPurchaseUseCase mockGetFullPurchaseUseCase =
      MockGetFullPurchaseUseCase();
  MockDeletePurchaseUseCase mockDeletePurchaseUseCase =
      MockDeletePurchaseUseCase();
  group('MockListPurchasesUseCase', () {
    group('MockListPurchasesUseCase happy path', () {
      final Stream<List<Purchase>> result =
          Stream<List<Purchase>>.fromIterable([
        List<Purchase>.from([Purchase()])
      ]);

      setUp(() {
        when(mockListPurchasesUseCase(NoParams()))
            .thenAnswer((realInvocation) async => Right(result));
      });

      blocTest('MockListPurchasesUseCase',
          build: () => PurchaseBloc(
              listPurchasesUseCase: mockListPurchasesUseCase,
              getFullPurchaseUseCase: mockGetFullPurchaseUseCase,
              deletePurchaseUseCase: mockDeletePurchaseUseCase),
          act: (bloc) => bloc.add(ListResumeEvent()),
          expect: () =>
              [PurchaseLoading(), ResumeListed(purchaseStreamList: result)]);
    });

    group('MockListPurchasesUseCase error path', () {
      final PurchaseFailure result =
          PurchaseFailure(messageId: MessageIds.UNEXPECTED, message: 'erro');

      setUp(() {
        when(mockListPurchasesUseCase(NoParams()))
            .thenAnswer((realInvocation) async => Left(result));
      });

      blocTest('MockListPurchasesUseCase',
          build: () => PurchaseBloc(
              listPurchasesUseCase: mockListPurchasesUseCase,
              getFullPurchaseUseCase: mockGetFullPurchaseUseCase,
              deletePurchaseUseCase: mockDeletePurchaseUseCase),
          act: (bloc) => bloc.add(ListResumeEvent()),
          expect: () =>
              [PurchaseLoading(), PurchaseError(purchaseFailure: result)]);
    });
  });

  group('GetPurchaseByIdEvent', () {
    group('Happy path', () {
      final result = Purchase();
      final purchaseId = 'purchaseId';

      setUp(() {
        when(mockGetFullPurchaseUseCase(Params(purchaseId: purchaseId)))
            .thenAnswer((realInvocation) async => Right(result));
      });

      blocTest('Happy',
          build: () => PurchaseBloc(
              getFullPurchaseUseCase: mockGetFullPurchaseUseCase,
              listPurchasesUseCase: mockListPurchasesUseCase,
              deletePurchaseUseCase: mockDeletePurchaseUseCase),
          act: (bloc) => bloc.add(GetPurchaseByIdEvent(purchaseId: purchaseId)),
          expect: () =>
              [PurchaseLoading(), PurchaseRetrieved(purchase: result)]);
    });

    group('Failure path', () {
      final PurchaseFailure result =
          PurchaseFailure(messageId: MessageIds.UNEXPECTED, message: 'erro');
      final purchaseId = 'purchaseId';

      setUp(() {
        when(mockGetFullPurchaseUseCase(Params(purchaseId: purchaseId)))
            .thenAnswer((realInvocation) async => Left(result));
      });

      blocTest('Failure',
          build: () => PurchaseBloc(
              getFullPurchaseUseCase: mockGetFullPurchaseUseCase,
              listPurchasesUseCase: mockListPurchasesUseCase,
              deletePurchaseUseCase: mockDeletePurchaseUseCase),
          act: (bloc) => bloc.add(GetPurchaseByIdEvent(purchaseId: purchaseId)),
          expect: () =>
              [PurchaseLoading(), PurchaseError(purchaseFailure: result)]);
    });
  });

  group('DeletePurchaseEvent', () {
    group('Happy path', () {
      final purchaseId = 'purchaseId';

      setUp(() {
        when(mockDeletePurchaseUseCase(
                deletePurchase.Params(purchaseId: purchaseId)))
            .thenAnswer((realInvocation) async => Right(null));
      });

      blocTest('Happy',
          build: () => PurchaseBloc(
              getFullPurchaseUseCase: mockGetFullPurchaseUseCase,
              listPurchasesUseCase: mockListPurchasesUseCase,
              deletePurchaseUseCase: mockDeletePurchaseUseCase),
          act: (bloc) => bloc.add(DeletePurchaseEvent(purchaseId: purchaseId)),
          expect: () => [PurchaseLoading(), PurchaseDeleted()]);
    });

    group('Failure path', () {
      final PurchaseFailure result =
          PurchaseFailure(messageId: MessageIds.UNEXPECTED, message: 'erro');
      final purchaseId = 'purchaseId';

      setUp(() {
        when(mockDeletePurchaseUseCase(
                deletePurchase.Params(purchaseId: purchaseId)))
            .thenAnswer((realInvocation) async => Left(result));
      });

      blocTest('Failure',
          build: () => PurchaseBloc(
              getFullPurchaseUseCase: mockGetFullPurchaseUseCase,
              listPurchasesUseCase: mockListPurchasesUseCase,
              deletePurchaseUseCase: mockDeletePurchaseUseCase),
          act: (bloc) => bloc.add(DeletePurchaseEvent(purchaseId: purchaseId)),
          expect: () =>
              [PurchaseLoading(), PurchaseError(purchaseFailure: result)]);
    });
  });
}
