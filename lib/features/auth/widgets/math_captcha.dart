import 'package:flutter/material.dart';
import 'dart:math';

/// Simple math CAPTCHA widget for robot verification
class MathCaptcha extends StatefulWidget {
  final Function(bool) onVerified;

  const MathCaptcha({super.key, required this.onVerified});

  @override
  State<MathCaptcha> createState() => _MathCaptchaState();
}

class _MathCaptchaState extends State<MathCaptcha> {
  final _captchaController = TextEditingController();
  late int _num1;
  late int _num2;
  late String _operator;
  late int _correctAnswer;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final random = Random();
    _num1 = random.nextInt(10) + 1; // 1-10
    _num2 = random.nextInt(10) + 1; // 1-10

    // Randomly choose operator (+ or -)
    final operators = ['+', '-'];
    _operator = operators[random.nextInt(operators.length)];

    // Calculate correct answer
    if (_operator == '+') {
      _correctAnswer = _num1 + _num2;
    } else {
      // Ensure no negative results
      if (_num1 < _num2) {
        final temp = _num1;
        _num1 = _num2;
        _num2 = temp;
      }
      _correctAnswer = _num1 - _num2;
    }

    _captchaController.clear();
    _isCorrect = null;
  }

  void _refreshCaptcha() {
    setState(() {
      _generateCaptcha();
      widget.onVerified(false);
    });
  }

  void _verifyCaptcha() {
    final userAnswer = int.tryParse(_captchaController.text);
    setState(() {
      _isCorrect = userAnswer == _correctAnswer;
      widget.onVerified(_isCorrect ?? false);
    });
  }

  @override
  void dispose() {
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _isCorrect == null
              ? Colors.blue.shade200
              : _isCorrect!
              ? Colors.green
              : Colors.red,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Verify you are human',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Math question
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      '$_num1 $_operator $_num2 = ?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Answer input
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _captchaController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      prefixIcon: _isCorrect == null
                          ? null
                          : Icon(
                              _isCorrect! ? Icons.check_circle : Icons.cancel,
                              color: _isCorrect! ? Colors.green : Colors.red,
                              size: 20,
                            ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _verifyCaptcha();
                      } else {
                        setState(() {
                          _isCorrect = null;
                          widget.onVerified(false);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Refresh button
                IconButton(
                  onPressed: _refreshCaptcha,
                  icon: const Icon(Icons.refresh),
                  color: Colors.blue[700],
                  tooltip: 'New question',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                ),
              ],
            ),
            if (_isCorrect == false) ...[
              const SizedBox(height: 8),
              Text(
                'Incorrect answer. Please try again.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (_isCorrect == true) ...[
              const SizedBox(height: 8),
              Text(
                '✓ Verification successful!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
