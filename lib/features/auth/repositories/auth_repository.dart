import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/user.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

/// Authentication repository - handles API calls and local storage
class AuthRepository {
  static const String _baseUrl = 'http://192.168.1.33/api';

  /// Encrypt password using MD5
  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  // ==================== API CALLS ====================

  /// Login user via API
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final encryptedPassword = _encryptPassword(request.password);

      final response = await http.post(
        Uri.parse('$_baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': request.username,
          'password': encryptedPassword,
        }),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        // Save user session automatically after successful login
        await saveUserSession(data);
        return LoginResponse.fromJson(data);
      } else {
        return LoginResponse(
          success: false,
          message: data['message'] as String? ?? 'Login failed',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Register new user via API
  Future<Map<String, dynamic>> registerUser(
    String username,
    String password,
  ) async {
    try {
      final encryptedPassword = _encryptPassword(password);

      final response = await http.post(
        Uri.parse('$_baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': encryptedPassword,
        }),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'user': User.fromJson(data),
        };
      } else if (response.statusCode == 409) {
        return {
          'success': false,
          'message': data['message'] ?? 'Username already exists',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  /// Check username availability
  Future<bool> checkUsernameExists(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/check/$username'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['exists'] as bool? ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==================== SESSION MANAGEMENT ====================

  /// Save user session to local storage
  Future<void> saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert string to int if needed (MySQL returns numbers as strings)
    final userId = userData['user_id'] is String
        ? int.parse(userData['user_id'])
        : userData['user_id'] as int;
    final isAdmin = userData['is_admin'] is String
        ? int.parse(userData['is_admin'])
        : (userData['is_admin'] ?? 0) as int;

    await prefs.setInt('user_id', userId);
    await prefs.setString('username', userData['username'] as String);
    await prefs.setInt('is_admin', isAdmin);
    await prefs.setBool('is_logged_in', true);
  }

  /// Get current user session
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!isLoggedIn) return null;

    return {
      'user_id': prefs.getInt('user_id'),
      'username': prefs.getString('username'),
      'is_admin': prefs.getInt('is_admin'),
    };
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  /// Get username from session
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  /// Logout user and clear session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ==================== REMEMBER PASSWORD ====================

  /// Save remembered credentials
  Future<void> saveRememberedCredentials(
    String username,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remembered_username', username);
    await prefs.setString('remembered_password', password);
    await prefs.setBool('remember_password', true);
  }

  /// Get remembered credentials
  Future<Map<String, String>?> getRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberPassword = prefs.getBool('remember_password') ?? false;

    if (rememberPassword) {
      final username = prefs.getString('remembered_username');
      final password = prefs.getString('remembered_password');

      if (username != null && password != null) {
        return {'username': username, 'password': password};
      }
    }
    return null;
  }

  /// Clear remembered credentials
  Future<void> clearRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remembered_username');
    await prefs.remove('remembered_password');
    await prefs.setBool('remember_password', false);
  }

  /// Check if remember password is enabled
  Future<bool> isRememberPasswordEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_password') ?? false;
  }
}
