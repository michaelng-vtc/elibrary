import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/password_visibility_toggle.dart';
import '../widgets/dialogs.dart';

/// Login page with clean architecture and Riverpod
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Trigger login
    await ref.read(authProvider.notifier).login(username, password);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<String?>(authProvider.select((state) => state.errorMessage), (
      previous,
      next,
    ) {
      if (next != null && next.isNotEmpty) {
        ErrorDialog.show(context, next);
        ref.read(authProvider.notifier).clearError();
      }
    });

    ref.listen<bool>(authProvider.select((state) => state.isAuthenticated), (
      previous,
      next,
    ) {
      if (next) {
        SuccessDialog.show(
          context,
          'Login successful!',
          onDismiss: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        );
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 48),
                  _buildUsernameField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 24),
                  _buildLoginButton(authState.isLoading),
                  const SizedBox(height: 16),
                  _buildRegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Icon(Icons.library_books, size: 80, color: Colors.blue),
        SizedBox(height: 16),
        Text(
          'E-Library',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return CustomTextField(
      controller: _usernameController,
      labelText: 'Username',
      prefixIcon: Icons.person,
      validator: _validateUsername,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      labelText: 'Password',
      prefixIcon: Icons.lock,
      validator: _validatePassword,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
      suffixIcon: PasswordVisibilityToggle(
        isVisible: !_obscurePassword,
        onToggle: _togglePasswordVisibility,
      ),
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return PrimaryButton(
      onPressed: _handleLogin,
      text: 'Login',
      isLoading: isLoading,
      icon: Icons.login,
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ", style: TextStyle(fontSize: 14)),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text(
            'Register',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
