import 'package:flutter/material.dart';

/// Reusable password visibility toggle button
class PasswordVisibilityToggle extends StatelessWidget {
  const PasswordVisibilityToggle({
    super.key,
    required this.isVisible,
    required this.onToggle,
  });

  final bool isVisible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      onPressed: onToggle,
      tooltip: isVisible ? 'Hide password' : 'Show password',
    );
  }
}
