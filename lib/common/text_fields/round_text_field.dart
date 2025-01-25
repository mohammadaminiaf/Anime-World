import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundTextField extends StatelessWidget {
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
  final bool isPassword;
  final TextInputType? keyboardType;

  const RoundTextField({
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
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: keyboardType,
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
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 14,
          ),
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefix,
          suffixIcon: suffix,
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
      ),
    );
  }
}

class RoundTextFieldMultiLine extends StatelessWidget {
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final String? helperText;
  final Widget? suffix;
  final Widget? prefix;
  final String? hintText;
  final String? defaultValue;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final bool? readonly;
  final int? maxLine;
  final int? maxLength;

  const RoundTextFieldMultiLine({
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLength: maxLength,
        maxLines: maxLine ?? 4,
        minLines: 1,
        controller: controller,
        readOnly: readonly ?? false,
        validator: validator,
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black87),
        focusNode: focusNode,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        onSaved: onSaved,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefix,
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.grey.shade100,
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
      ),
    );
  }
}
