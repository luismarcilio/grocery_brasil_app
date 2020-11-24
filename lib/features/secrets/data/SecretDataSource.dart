abstract class SecretDataSource {
  Future<String> getSecret(String secretName);
}
