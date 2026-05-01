import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository{
  final String baseUrl = "https://ternak-be-production.up.railway.app/api/v1";
  final _storage = const FlutterSecureStorage();

  Future<void> persistToken(String token)async {
    await _storage.write(key: 'jwt_token', value: token);
  }
}