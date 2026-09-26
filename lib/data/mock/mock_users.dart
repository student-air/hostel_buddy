import '../models/user_model.dart';

/// In-memory mock "database" of registered users, plus their passwords
/// (kept separate from UserModel since a real backend would never return
/// a password to the client). Resets every app restart — purely for
/// developing the flow before a real backend exists.
class MockUsers {
  MockUsers._();

  static final List<UserModel> _users = [
    const UserModel(
      id: 'u_seed_1',
      name: 'Ayesha Khan',
      email: 'ayesha@example.com',
      phone: '03001234567',
    ),
  ];

  static final Map<String, String> _passwords = {
    'ayesha@example.com': 'password123',
  };

  static List<UserModel> get all => List.unmodifiable(_users);

  static UserModel? findByEmail(String email) {
    try {
      return _users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  static bool checkPassword(String email, String password) {
    return _passwords[email.toLowerCase()] == password;
  }

  static UserModel add({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    final user = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
    );
    _users.add(user);
    _passwords[email.toLowerCase()] = password;
    return user;
  }

  static void updateRole(String userId, String role) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index] = _users[index].copyWith(role: role);
    }
  }
}
