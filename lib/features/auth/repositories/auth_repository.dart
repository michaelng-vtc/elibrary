import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../models/login_response.dart';

/// Authentication repository - handles API calls
class AuthRepository {
  static const String _baseUrl = 'http://192.168.1.195/api';

  /// Encrypt password using MD5
  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

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
        return LoginResponse.fromJson(data);
      } else {
        // Return error response
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
}
