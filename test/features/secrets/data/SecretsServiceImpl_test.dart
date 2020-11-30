import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:grocery_brasil_app/features/secrets/data/SecretDataSource.dart';
import 'package:grocery_brasil_app/features/secrets/data/SecretsServiceImpl.dart';
import 'package:grocery_brasil_app/features/secrets/domain/SecretsService.dart';
import 'package:mockito/mockito.dart';

class MockSecretDataSource extends Mock implements SecretDataSource {}

main() {
  MockSecretDataSource mockSecretDataSource;
  SecretsService sut;

  group('SecretsServiceImpl', () {
    setUp(() {
      mockSecretDataSource = MockSecretDataSource();
      sut = SecretsServiceImpl(secretDataSource: mockSecretDataSource);
    });
    test('should return secret from cache when available', () async {
      //setup
      final expected = 'SOME_SECRET';
      final secretName = 'SOME_SECRET_NAME';
      when(mockSecretDataSource.getSecret(secretName))
          .thenAnswer((realInvocation) async => expected);

      //act
      await sut.getSecret(secretName);
      final actual = await sut.getSecret(secretName);

      //assert
      expect(actual, expected);
      expect(verify(mockSecretDataSource.getSecret(secretName)).callCount, 1);
      verifyNoMoreInteractions(mockSecretDataSource);
    });
    test('should return the secret', () async {
      //setup
      final expected = 'SOME_SECRET';
      final secretName = 'SOME_SECRET_NAME';
      when(mockSecretDataSource.getSecret(secretName))
          .thenAnswer((realInvocation) async => expected);

      //act
      final actual = await sut.getSecret(secretName);

      //assert
      expect(actual, expected);
      verify(mockSecretDataSource.getSecret(secretName));
      verifyNoMoreInteractions(mockSecretDataSource);
    });

    test('should throw a secretsException when some error occurs', () {
      //setup
      final exception = Exception('some error');
      final secretName = 'SOME_SECRET_NAME';
      final expected = SecretsException(
          messageId: MessageIds.UNEXPECTED, message: 'Exception: some error');
      when(mockSecretDataSource.getSecret(secretName)).thenThrow(exception);
      //act
      //assert
      expect(() async => sut.getSecret(secretName), throwsA(expected));
    });
  });
}
