import 'package:anime_world/common/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final String? helperText;
  final Widget? suffix;
  final Widget? prefix;
  final String? hintText;
  final String? defaultValue;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final bool? readonly;
  final int? maxLine;
  final int? maxLength;
  final Color? hintColor;
  final bool? autoFocus;
  final Color? fillColor;
  final bool? autocorrect;
  final TextStyle? style;
  final bool isVerified;
  final VoidCallback onVerify;

  const EmailTextField({
    super.key,
    this.focusNode,
    this.onChanged,
    this.helperText,
    this.hintText,
    this.errorText,
    this.suffix,
    this.prefix,
    this.defaultValue,
    this.validator,
    this.onSaved,
    this.controller,
    this.padding,
    this.inputFormatters,
    this.readonly,
    this.maxLine,
    this.maxLength,
    this.onTap,
    this.hintColor,
    this.autoFocus,
    this.fillColor,
    this.autocorrect,
    this.style,
    this.isVerified = false,
    required this.onVerify,
  });

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  late ValueNotifier<bool> isVerifyVisible;

  @override
  void initState() {
    super.initState();
    isVerifyVisible =
        ValueNotifier<bool>(widget.controller?.text.isNotEmpty ?? false);
  }

  @override
  void dispose() {
    // Dispose the ValueNotifier to prevent memory leaks
    isVerifyVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final verifyButton = TextButton(
      onPressed: widget.onVerify,
      child: const Text('تایید'),
    );

    const verifiedText = Text('ایمیل تایید شده');

    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: isVerifyVisible,
        builder: (context, visible, child) {
          return TextFormField(
            maxLength: widget.maxLength,
            autocorrect: widget.autocorrect ?? true,
            controller: widget.controller,
            initialValue: widget.defaultValue,
            readOnly: widget.readonly ?? false,
            onTap: widget.onTap,
            validator: widget.validator ?? Validators.validateEmail,
            style: widget.style ?? theme.textTheme.bodyLarge,
            focusNode: widget.focusNode,
            autofocus: widget.autoFocus ?? false,
            onChanged: (value) {
              if (!visible && value.isNotEmpty) {
                isVerifyVisible.value = true;
              } else if (visible && value.isEmpty) {
                isVerifyVisible.value = false;
              }
              widget.onChanged?.call(value);
            },
            inputFormatters: widget.inputFormatters,
            keyboardType: TextInputType.emailAddress,
            onSaved: widget.onSaved,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: widget.hintColor,
                fontSize: 14,
              ),
              helperText: widget.helperText,
              errorText: widget.errorText,
              prefixIcon: widget.prefix,
              suffixIcon: visible
                  ? widget.isVerified
                      ? verifiedText
                      : verifyButton
                  : null,
              filled: true,
              fillColor: widget.fillColor ?? Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.red.shade300),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.red.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 16.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
