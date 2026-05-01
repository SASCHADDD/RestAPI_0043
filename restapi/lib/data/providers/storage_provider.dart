class StorageProvider {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  Future<void> saveToken(String token)async =>
  await _storage.write(key: _tokenKey, value: token);
}