import 'package:get_storage/get_storage.dart';

import '../../domain/repositories/i_auth_repository.dart';
import '../mock/mock_users.dart';
import '../models/user_model.dart';

/// Local/mock implementation of IAuthRepository. Persists only the current
/// user's id in GetStorage (so the session survives app restarts);
/// the user records themselves live in MockUsers, which resets on restart.
class LocalAuthRepository implements IAuthRepository {
  final _box = GetStorage();
  static const _sessionKey = 'session_user_id';

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (MockUsers.findByEmail(email) != null) {
      throw Exception('An account with this email already exists');
    }

    final user = MockUsers.add(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    await _box.write(_sessionKey, user.id);
    return user;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final user = MockUsers.findByEmail(email);
    if (user == null || !MockUsers.checkPassword(email, password)) {
      throw Exception('Incorrect email or password');
    }

    await _box.write(_sessionKey, user.id);
    return user;
  }

  @override
  Future<void> logout() async {
    await _box.remove(_sessionKey);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final id = _box.read<String>(_sessionKey);
    if (id == null) return null;
    try {
      return MockUsers.all.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel> setRole({
    required String userId,
    required String role,
  }) async {
    MockUsers.updateRole(userId, role);
    return MockUsers.all.firstWhere((u) => u.id == userId);
  }
}
