import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Local storage for authentication data
class AuthLocalDataSource {
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyIsAdmin = 'is_admin';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Save user session
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, user.userId);
    await prefs.setString(_keyUsername, user.username);
    await prefs.setInt(_keyIsAdmin, user.isAdmin);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// Get current user from local storage
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return null;

    final userId = prefs.getInt(_keyUserId);
    final username = prefs.getString(_keyUsername);

    if (userId == null || username == null) return null;

    return User(
      userId: userId,
      username: username,
      isAdmin: prefs.getInt(_keyIsAdmin) ?? 0,
    );
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Clear user session
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
