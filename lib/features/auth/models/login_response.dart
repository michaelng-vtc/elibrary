import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/converters/json_converters.dart';
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
    @JsonKey(
      name: 'user_id',
      fromJson: nullableStringToInt,
      toJson: intToNullableString,
    )
    int? userId,
    String? username,
    @JsonKey(
      name: 'is_admin',
      fromJson: nullableStringToInt,
      toJson: intToNullableString,
    )
    int? isAdmin,
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
