import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final String? helperText;
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

  const PasswordTextField({
    super.key,
    this.focusNode,
    this.onChanged,
    this.helperText,
    this.hintText,
    this.errorText,
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: isPasswordVisible,
        builder: (context, isVisible, child) {
          return TextFormField(
            maxLength: maxLength,
            autocorrect: autocorrect ?? true,
            controller: controller,
            initialValue: defaultValue,
            readOnly: readonly ?? false,
            onTap: onTap,
            validator: validator,
            style: style ?? theme.textTheme.bodyLarge,
            focusNode: focusNode,
            autofocus: autoFocus ?? false,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            onSaved: onSaved,
            obscureText: !isVisible, // Toggle visibility based on isVisible
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: hintColor,
                fontSize: 14,
              ),
              helperText: helperText,
              errorText: errorText,
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
              ),
              filled: true,
              fillColor: fillColor ?? Colors.transparent,
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
