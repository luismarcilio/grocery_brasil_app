import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/Address.dart';
import 'package:grocery_brasil_app/domain/Company.dart';
import 'package:grocery_brasil_app/domain/FiscalNote.dart';
import 'package:grocery_brasil_app/domain/Location.dart';
import 'package:grocery_brasil_app/domain/Purchase.dart';
import 'package:grocery_brasil_app/features/common/data/PurchaseDataSource.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockQuery extends Mock implements Query {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

main() {
  MockFirebaseFirestore mockFirebaseFirestore;
  MockCollectionReference mockCompras;
  MockCollectionReference mockResumida;
  MockCollectionReference mockCompleta;
  MockDocumentReference mockUserDocument;
  MockDocumentReference mockPurchaseDocument;
  MockQuery mockOrderBy;
  MockQuerySnapshot mockQuerySnapshot;
  MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  PurchaseDataSource purchaseDataSource;
  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCompras = MockCollectionReference();
    mockResumida = MockCollectionReference();
    mockCompleta = MockCollectionReference();
    mockUserDocument = MockDocumentReference();
    mockPurchaseDocument = MockDocumentReference();
    mockOrderBy = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    purchaseDataSource =
        PurchaseDataSourceImpl(firebaseFirestore: mockFirebaseFirestore);
  });

  group('listPurchaseResume', () {
    test('should return the list of purchases when all ok', () {
//setup
      final userId = '1';
      final purchase = Purchase(
        totalAmount: 10.0,
        fiscalNote: FiscalNote(
          company: Company(
            name: 'companyName',
            address: Address(
                rawAddress: 'rawAddress',
                state: State(name: 'state'),
                country: Country(name: 'country'),
                city: City(name: 'city'),
                location: Location(lat: 0.0, lon: 0.0)),
          ),
        ),
      );
      final databaseDoc = Map<String, dynamic>.from({
        'totalAmount': 10.0,
        'company': Map<String, dynamic>.from({
          'name': 'companyName',
          'address': Map<String, dynamic>.from({
            'rawAddress': 'rawAddress',
            'state': Map<String, dynamic>.from({'name': 'state'}),
            'country': Map<String, dynamic>.from({'name': 'country'}),
            'city': Map<String, dynamic>.from({'name': 'city'}),
            'location': Map<String, dynamic>.from({'lat': 0.0, 'lon': 0.0}),
          })
        })
      });
      final List<Purchase> expected = List<Purchase>.from([purchase]);

      when(mockFirebaseFirestore.collection('COMPRAS'))
          .thenAnswer((realInvocation) => mockCompras);
      when(mockCompras.doc(userId))
          .thenAnswer((realInvocation) => mockUserDocument);
      when(mockUserDocument.collection('RESUMIDA'))
          .thenAnswer((realInvocation) => mockResumida);
      when(mockResumida.orderBy('date', descending: true))
          .thenAnswer((realInvocation) => mockOrderBy);
      when(mockOrderBy.snapshots()).thenAnswer((realInvocation) =>
          Stream<QuerySnapshot>.fromIterable([mockQuerySnapshot]));
      when(mockQuerySnapshot.docs).thenAnswer((realInvocation) =>
          List<QueryDocumentSnapshot>.from([mockQueryDocumentSnapshot]));
      when(mockQueryDocumentSnapshot.exists)
          .thenAnswer((realInvocation) => true);
      when(mockQueryDocumentSnapshot.data())
          .thenAnswer((realInvocation) => databaseDoc);

//act
      final actual = purchaseDataSource.listPurchaseResume(userId: userId);
//assert
      expect(actual, emitsInOrder([expected]));
    });
  });
  group('getPurchaseById', () {
    test('should retrieve the purchase when all ok', () async {
      //setup
      final userId = 'userId';
      final purchaseId = 'purchaseId';

      final purchase = Purchase(
        totalAmount: 10.0,
        fiscalNote: FiscalNote(
          date: DateTime(2020, 01, 01),
          company: Company(
            name: 'companyName',
            address: Address(
                rawAddress: 'rawAddress',
                state: State(name: 'state'),
                country: Country(name: 'country'),
                city: City(name: 'city'),
                location: Location(lat: 0.0, lon: 0.0)),
          ),
        ),
      );
      final databaseDoc = Map<String, dynamic>.from({
        'totalAmount': 10.0,
        'purchaseItemList': [],
        'fiscalNote': Map<String, dynamic>.from({
          'date': '2020-01-01 00:00:00.000',
          'company': Map<String, dynamic>.from({
            'name': 'companyName',
            'address': Map<String, dynamic>.from({
              'rawAddress': 'rawAddress',
              'state': Map<String, dynamic>.from({'name': 'state'}),
              'country': Map<String, dynamic>.from({'name': 'country'}),
              'city': Map<String, dynamic>.from({'name': 'city'}),
              'location': Map<String, dynamic>.from({'lat': 0.0, 'lon': 0.0}),
            })
          })
        })
      });

      when(mockFirebaseFirestore.collection('COMPRAS'))
          .thenAnswer((realInvocation) => mockCompras);
      when(mockCompras.doc(userId))
          .thenAnswer((realInvocation) => mockUserDocument);
      when(mockUserDocument.collection('COMPLETA'))
          .thenAnswer((realInvocation) => mockCompleta);
      when(mockCompleta.doc(purchaseId))
          .thenAnswer((realInvocation) => mockPurchaseDocument);
      when(mockPurchaseDocument.get())
          .thenAnswer((realInvocation) async => mockQueryDocumentSnapshot);
      when(mockQueryDocumentSnapshot.exists)
          .thenAnswer((realInvocation) => true);
      when(mockQueryDocumentSnapshot.data())
          .thenAnswer((realInvocation) => databaseDoc);

      //act
      final actual = await purchaseDataSource.getPurchaseById(
          purchaseId: purchaseId, userId: userId);
      //assert
      expect(actual, purchase);
    });

    test('should throw not found when not found', () async {
//setup
      final userId = 'userId';
      final purchaseId = 'purchaseId';
      final expected = PurchaseException(messageId: MessageIds.NOT_FOUND);

      when(mockFirebaseFirestore.collection('COMPRAS'))
          .thenAnswer((realInvocation) => mockCompras);
      when(mockCompras.doc(userId))
          .thenAnswer((realInvocation) => mockUserDocument);
      when(mockUserDocument.collection('COMPLETA'))
          .thenAnswer((realInvocation) => mockCompleta);
      when(mockCompleta.doc(purchaseId))
          .thenAnswer((realInvocation) => mockPurchaseDocument);
      when(mockPurchaseDocument.get())
          .thenAnswer((realInvocation) async => mockQueryDocumentSnapshot);
      when(mockQueryDocumentSnapshot.exists)
          .thenAnswer((realInvocation) => false);
      when(mockQueryDocumentSnapshot.data())
          .thenAnswer((realInvocation) => null);

      //assert
      expect(
          () async => await purchaseDataSource.getPurchaseById(
              purchaseId: purchaseId, userId: userId),
          throwsA(expected));
    });
  });
}
