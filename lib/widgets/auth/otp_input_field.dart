import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final int otpLength; // Number of OTP fields

  const OtpInputField({
    super.key,
    required this.onChanged,
    this.otpLength = 6,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes based on otpLength
    _controllers = List.generate(
      widget.otpLength,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.otpLength, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < widget.otpLength - 1) {
      _focusNodes[index + 1].requestFocus(); // Move to the next field
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus(); // Move to the previous field
    }

    // Update the OTP value
    final otp = _controllers.map((controller) => controller.text).join();
    widget.onChanged(otp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 120,
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          widget.otpLength,
          (index) => Expanded(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.hintColor.withAlpha(50),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) => _onChanged(value, index),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.scaffoldBackgroundColor,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    counter: const SizedBox.shrink(),
                  ),
                  cursorColor: Colors.blue,
                  cursorWidth: 2,
                  showCursor: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
