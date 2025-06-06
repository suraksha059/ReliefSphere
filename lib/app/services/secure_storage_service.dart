import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String userId = 'userId';
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  FlutterSecureStorage get storage => _storage;

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<String?> getUserId() {
    return read(SecureStorageService.userId);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> saveUserId(String userId) async {
    await write(SecureStorageService.userId, userId);
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
}
