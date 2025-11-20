import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// Authentication state using freezed for immutability
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? username,
    int? userId,
    @Default(false) bool isAdmin,
    String? errorMessage,
  }) = _AuthState;
}
