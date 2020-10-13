import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/apisDetails/data/FunctionsDetailsDataSource.dart';
import 'package:grocery_brasil_app/features/apisDetails/domain/BackendFunctionsConfiguration.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

main() {
  MockFirebaseFirestore mockFirebaseFirestore;
  MockCollectionReference mockCollectionReference;
  MockDocumentReference mockDocumentReference;
  MockDocumentSnapshot mockDocumentSnapshot;
  FunctionsDetailsDataSource functionsDetailsDataSource;

  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
    functionsDetailsDataSource = FunctionsDetailsDataSourceImpl(
        firebaseFirestore: mockFirebaseFirestore);
  });

  group('FunctionsDetailsDataSourceImpl', () {
    test('should return BackendFunctionsConfiguration when all ok', () async {
      //setup
      final expected = BackendFunctionsConfiguration(
          host: 'host', port: 666, path: '/test', scheme: 'https');
      when(mockFirebaseFirestore.collection('apiConfiguration'))
          .thenAnswer((realInvocation) => mockCollectionReference);
      when(mockCollectionReference.doc('v1'))
          .thenAnswer((realInvocation) => mockDocumentReference);
      when(mockDocumentReference.get())
          .thenAnswer((realInvocation) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenAnswer((realInvocation) => true);
      when(mockDocumentSnapshot.data()).thenAnswer((realInvocation) =>
          Map<String, dynamic>.from({
            'host': 'host',
            'port': 666,
            'path': '/test',
            'scheme': 'https'
          }));
      //act
      final actual =
          await functionsDetailsDataSource.getBackendFunctionsConfiguration();
      //assert
      expect(actual, expected);
    });

    test('should throw  exception when not found', () async {
      //setup
      final expected =
          FunctionsDetailsDataSourceException(messageId: MessageIds.NOT_FOUND);
      when(mockFirebaseFirestore.collection('apiConfiguration'))
          .thenAnswer((realInvocation) => mockCollectionReference);
      when(mockCollectionReference.doc('v1'))
          .thenAnswer((realInvocation) => mockDocumentReference);
      when(mockDocumentReference.get())
          .thenAnswer((realInvocation) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenAnswer((realInvocation) => false);

      //assert
      expect(
          () async => await functionsDetailsDataSource
              .getBackendFunctionsConfiguration(),
          throwsA(expected));
    });
  });
}
