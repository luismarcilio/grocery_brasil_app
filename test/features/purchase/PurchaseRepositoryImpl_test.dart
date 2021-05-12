import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/core/errors/failures.dart';
import 'package:grocery_brasil_app/domain/Purchase.dart';
import 'package:grocery_brasil_app/features/login/data/datasources/AuthenticationDataSource.dart';
import 'package:grocery_brasil_app/features/purchase/data/PurchaseDataSource.dart';
import 'package:grocery_brasil_app/features/purchase/data/PurchaseRepositoryImpl.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/data/NFDataSource.dart';
import 'package:grocery_brasil_app/features/readNfFromSite/domain/model/NfHtmlFromSite.dart';
import 'package:mockito/mockito.dart';

class MockNFDataSource extends Mock implements NFDataSource {}

class MockPurchaseDataSource extends Mock implements PurchaseDataSource {}

class MockAuthenticationDataSource extends Mock
    implements AuthenticationDataSource {}

main() {
  MockNFDataSource mockNFDataSource;
  MockPurchaseDataSource mockPurchaseDataSource;
  MockAuthenticationDataSource mockAuthenticationDataSource;
  PurchaseRepositoryImpl purchaseRepositoryImpl;
  setUp(() {
    mockNFDataSource = MockNFDataSource();
    mockPurchaseDataSource = MockPurchaseDataSource();
    mockAuthenticationDataSource = MockAuthenticationDataSource();
    purchaseRepositoryImpl = PurchaseRepositoryImpl(
        authenticationDataSource: mockAuthenticationDataSource,
        nfDataSource: mockNFDataSource,
        purchaseDataSource: mockPurchaseDataSource);
  });

  group('save', () {
    test('should return ok when no error happens', () async {
      //setup
      final nfHtmlFromSite = NfHtmlFromSite(html: "html", uf: 'MG');
      when(mockNFDataSource.save(nfHtmlFromSite: nfHtmlFromSite))
          .thenAnswer((realInvocation) async => nfHtmlFromSite);
      //act
      final actual =
          await purchaseRepositoryImpl.save(nfHtmlFromSite: nfHtmlFromSite);
      //assert
      expect(actual, Right(nfHtmlFromSite));
    });

    test('should throw an exception when an error happens', () async {
      //setup
      final nfHtmlFromSite = NfHtmlFromSite(html: "html", uf: 'MG');
      final purchaseFailure = PurchaseFailure(
          messageId: MessageIds.UNEXPECTED,
          message: "Operação falhou. (Mensagem original: [Exception: erro])");
      when(mockNFDataSource.save(nfHtmlFromSite: nfHtmlFromSite))
          .thenThrow(Exception('erro'));
      //act
      final actual =
          await purchaseRepositoryImpl.save(nfHtmlFromSite: nfHtmlFromSite);
      //assert
      expect(actual, Left(purchaseFailure));
    });
  });

  group('listPurchaseResume', () {
    test('should retrieve the list of purchases when all ok', () async {
//setup
      final Stream<List<Purchase>> expected =
          Stream<List<Purchase>>.fromIterable([
        List<Purchase>.from([Purchase()])
      ]);
      final userId = '1';
      when(mockAuthenticationDataSource.getUserId())
          .thenAnswer((realInvocation) => userId);
      when(mockPurchaseDataSource.listPurchaseResume(userId: userId))
          .thenAnswer((realInvocation) => expected);
//act
      final actual = await purchaseRepositoryImpl.listPurchaseResume();

//assert
      expect(actual, Right(expected));
    });
  });

  test('should return failure when an exception occurs', () async {
    //setup
    final expected = PurchaseFailure(
        messageId: MessageIds.UNEXPECTED,
        message: "Operação falhou. (Mensagem original: [Exception: erro])");
    final userId = '1';
    when(mockAuthenticationDataSource.getUserId())
        .thenAnswer((realInvocation) => userId);
    when(mockPurchaseDataSource.listPurchaseResume(userId: userId))
        .thenThrow(Exception('erro'));

    //act
    final actual = await purchaseRepositoryImpl.listPurchaseResume();

    //assert
    expect(actual, Left(expected));
  });

  group('getPurchaseById', () {
    test('should retrieve purchase when all ok', () async {
      //setup
      final purchase = Purchase();
      final purchaseId = '1';
      final userId = '1';
      when(mockAuthenticationDataSource.getUserId())
          .thenAnswer((realInvocation) => userId);
      when(mockPurchaseDataSource.getPurchaseById(
              purchaseId: purchaseId, userId: userId))
          .thenAnswer((realInvocation) async => purchase);
      //act
      final actual =
          await purchaseRepositoryImpl.getPurchaseById(purchaseId: purchaseId);
      //assert

      expect(actual, Right(purchase));
    });

    test('should return failure when an exception occurs', () async {
      //setup
      final purchaseId = '1';
      final userId = '1';
      final expected = PurchaseFailure(
          messageId: MessageIds.UNEXPECTED,
          message: "Operação falhou. (Mensagem original: [Exception: erro])");
      when(mockAuthenticationDataSource.getUserId())
          .thenAnswer((realInvocation) => userId);
      when(mockPurchaseDataSource.getPurchaseById(
              purchaseId: purchaseId, userId: userId))
          .thenThrow(Exception('erro'));

      //act
      final actual =
          await purchaseRepositoryImpl.getPurchaseById(purchaseId: purchaseId);
      //assert

      expect(actual, Left(expected));
    });
  });

  group('deletePurchase', () {
    test('should delete purchase when all ok', () async {
      //setup
      final purchaseId = '1';
      final userId = '1';
      when(mockAuthenticationDataSource.getUserId())
          .thenAnswer((realInvocation) => userId);
      when(mockPurchaseDataSource.deletePurchaseById(
              purchaseId: purchaseId, userId: userId))
          .thenAnswer((realInvocation) => null);
      //act
      final actual =
          await purchaseRepositoryImpl.deletePurchase(purchaseId: purchaseId);
      //assert

      expect(actual, Right(null));
      verify(mockPurchaseDataSource.deletePurchaseById(
              purchaseId: '1', userId: '1'))
          .called(1);
    });

    test('should return failure when an exception occurs', () async {
      //setup
      final purchaseId = '1';
      final userId = '1';
      when(mockAuthenticationDataSource.getUserId())
          .thenAnswer((realInvocation) => userId);
      final expected = PurchaseFailure(
          messageId: MessageIds.UNEXPECTED,
          message: "Operação falhou. (Mensagem original: [Exception: erro])");
      when(mockPurchaseDataSource.deletePurchaseById(
              purchaseId: purchaseId, userId: userId))
          .thenThrow(Exception('erro'));

      //act
      final actual =
          await purchaseRepositoryImpl.deletePurchase(purchaseId: purchaseId);
      //assert

      expect(actual, Left(expected));
    });
  });
}
