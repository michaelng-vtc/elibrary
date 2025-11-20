import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Login API response
@freezed
class LoginResponse with _$LoginResponse {
  const LoginResponse._(); // Private constructor for custom methods

  const factory LoginResponse({
    required bool success,
    required String message,
    @JsonKey(name: 'user_id') int? userId,
    String? username,
    @JsonKey(name: 'is_admin') int? isAdmin,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  /// Convert response to User model
  User? toUser() {
    if (userId != null && username != null) {
      return User(userId: userId!, username: username!, isAdmin: isAdmin ?? 0);
    }
    return null;
  }
}
