import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/pages/home_page.dart';
import 'features/books/pages/add_book_page.dart';
import 'features/books/pages/all_books_page.dart';
import 'features/auth/pages/register_page.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const AuthGuard(child: HomePage()),
        '/books': (context) => const AuthGuard(child: AllBooksPage()),
        '/add': (context) => const AuthGuard(child: AddBookPage()),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

// Authentication Guard Widget with Riverpod
class AuthGuard extends ConsumerStatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  ConsumerState<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends ConsumerState<AuthGuard> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait for auth state to initialize
    await Future.delayed(const Duration(milliseconds: 100));

    final authState = ref.read(authProvider);

    if (!authState.isAuthenticated && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return widget.child;
  }
}
