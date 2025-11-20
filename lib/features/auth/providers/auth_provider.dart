import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/login_request.dart';
import '../repositories/auth_repository.dart';
import '../repositories/auth_local_datasource.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Auth local data source provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

/// Auth state notifier - manages authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository, this._localDataSource)
    : super(const AuthState()) {
    _initAuth();
  }

  final AuthRepository _repository;
  final AuthLocalDataSource _localDataSource;

  /// Initialize authentication state from local storage
  Future<void> _initAuth() async {
    final user = await _localDataSource.getUser();
    if (user != null) {
      state = state.copyWith(
        isAuthenticated: true,
        username: user.username,
        userId: user.userId,
        isAdmin: user.isAdmin == 1,
      );
    }
  }

  /// Login with username and password
  Future<void> login(String username, String password) async {
    // Validate inputs
    if (username.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'Username is required',
        isLoading: false,
      );
      return;
    }

    if (password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Password is required',
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final request = LoginRequest(
        username: username.trim(),
        password: password,
      );

      final response = await _repository.login(request);

      if (response.success) {
        final user = response.toUser();
        if (user != null) {
          await _localDataSource.saveUser(user);

          state = state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            username: user.username,
            userId: user.userId,
            isAdmin: user.isAdmin == 1,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid response from server',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _localDataSource.clearUser();
    state = const AuthState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(authLocalDataSourceProvider),
  );
});
