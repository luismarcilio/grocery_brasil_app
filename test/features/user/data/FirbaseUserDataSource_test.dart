import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/domain/User.dart';
import 'package:grocery_brasil_app/features/user/data/FirbaseUserDataSource.dart';
import 'package:grocery_brasil_app/features/user/data/UserDataSource.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

main() {
  MockFirebaseFirestore mockFirebaseFirestore = MockFirebaseFirestore();
  MockCollectionReference collection = MockCollectionReference();
  MockDocumentReference document = MockDocumentReference();
  MockDocumentSnapshot docSnapshot = MockDocumentSnapshot();

  final UserDataSource sut =
      FirbaseUserDataSource(firebaseFirestore: mockFirebaseFirestore);
  group('FirbaseUserDataSource', () {
    group('createUser', () {
      test('should create user  ', () async {
        //setup
        final someUser = User(userId: 'someUserId', email: 'someEmail');

        when(mockFirebaseFirestore.collection('USUARIOS'))
            .thenReturn(collection);
        when(collection.doc(someUser.userId)).thenReturn(document);
        when(document.set(someUser.toJson()))
            .thenAnswer((realInvocation) => Future.value());

        //act
        final expected = await sut.createUser(someUser);
        //assert
        expect(expected, someUser);
        verify(mockFirebaseFirestore.collection('USUARIOS'));
        verifyNoMoreInteractions(mockFirebaseFirestore);
        verify(collection.doc(someUser.userId));
        verifyNoMoreInteractions(collection);
        verify(document.set(someUser.toJson()));
        verifyNoMoreInteractions(document);
      });

      test('should throw UserExcepion when some error occurs', () async {
//setup
        //setup
        final someUser = User(userId: 'someUserId', email: 'someEmail');
        final expected = UserException(
            messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');

        when(mockFirebaseFirestore.collection('USUARIOS'))
            .thenThrow(Exception('some error'));

        //act

        //assert

        expect(() async => await sut.createUser(someUser), throwsA(expected));
      });
    });

    group('getUserByUserId', () {
      test('should getUserByUserId  ', () async {
        //setup
        final someUser = User(userId: 'someUserId', email: 'someEmail');

        when(mockFirebaseFirestore.collection('USUARIOS'))
            .thenReturn(collection);
        when(collection.doc(someUser.userId)).thenReturn(document);
        when(document.get()).thenAnswer((realInvocation) async => docSnapshot);
        when(docSnapshot.exists).thenReturn(true);
        when(docSnapshot.data()).thenReturn(someUser.toJson());
        //act
        final actual = await sut.getUserByUserId('someUserId');
        //assert
        expect(actual, someUser);
        verify(mockFirebaseFirestore.collection('USUARIOS'));
        verifyNoMoreInteractions(mockFirebaseFirestore);
        verify(collection.doc(someUser.userId));
        verifyNoMoreInteractions(collection);
        verify(document.get());
        verifyNoMoreInteractions(document);
        verify(docSnapshot.exists);
        verify(docSnapshot.data());
        verifyNoMoreInteractions(docSnapshot);
      });
      test('should throw UserExcepion NOT_FOUND when user not found', () async {
        //setup
        final someUser = User(userId: 'someUserId', email: 'someEmail');
        final expected = UserException(
            messageId: MessageIds.NOT_FOUND,
            message: 'User ${someUser.userId} not found');

        when(mockFirebaseFirestore.collection('USUARIOS'))
            .thenReturn(collection);
        when(collection.doc(someUser.userId)).thenReturn(document);
        when(document.get()).thenAnswer((realInvocation) async => docSnapshot);
        when(docSnapshot.exists).thenReturn(false);
        //act
        //assert
        expect(() async => await sut.getUserByUserId('someUserId'),
            throwsA(expected));
      });
      test('should throw UserExcepion when some error occurs', () {
        //setup
        final expected = UserException(
            messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');

        when(mockFirebaseFirestore.collection('USUARIOS'))
            .thenThrow(Exception('some error'));

        //act

        //assert
        expect(() async => await sut.getUserByUserId('someUserId'),
            throwsA(expected));
      });
    });
  });
}
