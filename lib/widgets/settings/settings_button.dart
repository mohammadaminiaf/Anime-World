import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const SettingsButton({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onPressed,
      title: Text(
        title,
        style: theme.textTheme.bodyMedium,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
    );
  }
}
