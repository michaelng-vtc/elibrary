import 'package:flutter/material.dart';
import '../../../services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final username = await _authService.getUsername();
    setState(() {
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Library Home'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_username != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _username!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      drawer: AppDrawer(username: _username),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.library_books, size: 120, color: Colors.blue),
              const SizedBox(height: 32),
              Text(
                'Welcome to E-Library',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),
              if (_username != null)
                Text(
                  'Hello, $_username!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Manage your book collection with ease',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _QuickActionCard(
                    icon: Icons.add_circle,
                    label: 'Add Book',
                    color: Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/add'),
                  ),
                  const SizedBox(width: 24),
                  _QuickActionCard(
                    icon: Icons.list_alt,
                    label: 'View All Books',
                    color: Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/books'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final String? username;

  const AppDrawer({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.library_books, size: 48, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'E-Library',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (username != null)
                  Text(
                    'Logged in as: $username',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  )
                else
                  const Text(
                    'Book Management System',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt, color: Colors.orange),
            title: const Text('All Books'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/books');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.green),
            title: const Text('Add Book'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/add');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () async {
              final authService = AuthService();
              await authService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'E-Library',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.library_books, size: 48),
                children: [
                  const Text(
                    'A comprehensive book management system for managing your library collection.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
