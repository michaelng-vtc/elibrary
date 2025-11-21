import 'package:flutter/material.dart';

/// Password strength levels
enum PasswordStrength { weak, medium, strong, veryStrong }

/// Widget to display password strength with visual indicator
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  /// Calculate password strength based on criteria
  PasswordStrength _calculateStrength() {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Uppercase letter
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;

    // Lowercase letter
    if (RegExp(r'[a-z]').hasMatch(password)) score++;

    // Numbers
    if (RegExp(r'[0-9]').hasMatch(password)) score++;

    // Special characters
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    // Determine strength level
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.medium;
    if (score <= 4) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  /// Get strength details
  Map<String, dynamic> _getStrengthDetails() {
    final strength = _calculateStrength();
    switch (strength) {
      case PasswordStrength.weak:
        return {'text': 'Weak', 'color': Colors.red, 'progress': 0.25};
      case PasswordStrength.medium:
        return {'text': 'Medium', 'color': Colors.orange, 'progress': 0.5};
      case PasswordStrength.strong:
        return {'text': 'Strong', 'color': Colors.lightGreen, 'progress': 0.75};
      case PasswordStrength.veryStrong:
        return {'text': 'Very Strong', 'color': Colors.green, 'progress': 1.0};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final details = _getStrengthDetails();
    final color = details['color'] as Color;
    final progress = details['progress'] as double;
    final text = details['text'] as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Password Strength: ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

/// Widget to display password requirements checklist
class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  bool get _hasMinLength => password.length >= 8;
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(password);
  bool get _hasSpecialChar =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'Password Requirements:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRequirement('At least 8 characters', _hasMinLength),
          const SizedBox(height: 4),
          _buildRequirement(
            'At least one uppercase letter (A-Z)',
            _hasUppercase,
          ),
          const SizedBox(height: 4),
          _buildRequirement(
            'At least one special character (!@#\$%...)',
            _hasSpecialChar,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: isMet ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green[700] : Colors.grey[600],
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
