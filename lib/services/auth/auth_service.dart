import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/user.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.195/api';

  // Encrypt password using MD5
  String encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  // Check if username already exists
  Future<bool> checkUsernameExists(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/check/$username'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'] == true;
      }
      return false;
    } catch (e) {
      throw Exception('Error checking username: $e');
    }
  }

  // Register new user
  Future<Map<String, dynamic>> registerUser(
    String username,
    String password,
  ) async {
    try {
      // Encrypt password before sending
      final encryptedPassword = encryptPassword(password);

      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': encryptedPassword,
        }),
      );

      final data = json.decode(response.body);

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

  // Login user
  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    try {
      // Encrypt password before sending
      final encryptedPassword = encryptPassword(password);

      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': encryptedPassword,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Save user session
        await saveUserSession(data);

        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'user': User.fromJson(data),
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Save user session
  Future<void> saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userData['user_id']);
    await prefs.setString('username', userData['username']);
    await prefs.setInt('is_admin', userData['is_admin'] ?? 0);
    await prefs.setBool('is_logged_in', true);
  }

  // Get current user session
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

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Get username from session
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
