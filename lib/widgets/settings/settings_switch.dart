import 'package:flutter/cupertino.dart';

class SettingsSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
