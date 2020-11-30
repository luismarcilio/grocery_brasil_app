import 'package:grocery_brasil_app/core/errors/exceptions.dart';
import 'package:meta/meta.dart';

import '../domain/SecretsService.dart';
import 'SecretDataSource.dart';

class SecretsServiceImpl implements SecretsService {
  final SecretDataSource secretDataSource;
  final secretCache = new Map<String, String>();

  SecretsServiceImpl({@required this.secretDataSource});

  @override
  Future<String> getSecret(String secretName) async {
    if (secretCache.containsKey(secretName)) {
      return secretCache[secretName];
    }
    try {
      final secret = await this.secretDataSource.getSecret(secretName);
      secretCache[secretName] = secret;
      return secret;
    } catch (e) {
      if (e is SecretsException) {
        throw e;
      }
      throw SecretsException(
          messageId: MessageIds.UNEXPECTED, message: e.toString());
    }
  }
}
