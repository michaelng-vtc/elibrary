import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/password_visibility_toggle.dart';
import '../widgets/dialogs.dart';
import '../widgets/math_captcha.dart';
import '../repositories/auth_repository.dart';

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
  final _authRepository = AuthRepository();
  bool _obscurePassword = true;
  bool _captchaVerified = false;
  bool _rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final credentials = await _authRepository.getRememberedCredentials();
    if (credentials != null) {
      setState(() {
        _usernameController.text = credentials['username']!;
        _passwordController.text = credentials['password']!;
        _rememberPassword = true;
      });
    }
  }

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

    if (!_captchaVerified) {
      ErrorDialog.show(context, 'Please complete the verification');
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Save or clear remembered credentials based on checkbox
    if (_rememberPassword) {
      await _authRepository.saveRememberedCredentials(username, password);
    } else {
      await _authRepository.clearRememberedCredentials();
    }

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
                  _buildStudentInfoCard(),
                  const SizedBox(height: 32),
                  _buildHeader(),
                  const SizedBox(height: 48),
                  _buildUsernameField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  MathCaptcha(
                    onVerified: (verified) {
                      setState(() {
                        _captchaVerified = verified;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildRememberPasswordCheckbox(),
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

  Widget _buildStudentInfoCard() {
    return Card(
      elevation: 4,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.person_outline, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            const Text(
              'Developed By',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'NgChingWai',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'ID: 240437702',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
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

  Widget _buildRememberPasswordCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberPassword,
          onChanged: (value) {
            setState(() {
              _rememberPassword = value ?? false;
            });
          },
          activeColor: Colors.blue,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _rememberPassword = !_rememberPassword;
              });
            },
            child: const Text(
              'Remember password',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
      ],
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
