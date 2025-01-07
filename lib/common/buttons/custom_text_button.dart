import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  /// Default constructor with custom padding
  const CustomTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.all(12.0),
  });

  /// Constructor for end padding (right or trailing side)
  CustomTextButton.endPadding({
    super.key,
    required this.label,
    required this.onPressed,
    double endPadding = 12.0,
  }) : padding = EdgeInsets.only(right: endPadding);

  /// Constructor for horizontal padding
  CustomTextButton.horizontalPadding({
    super.key,
    required this.label,
    required this.onPressed,
    double horizontalPadding = 12.0,
  }) : padding = EdgeInsets.symmetric(horizontal: horizontalPadding);

  /// Constructor for all sides padding
  CustomTextButton.allPadding({
    super.key,
    required this.label,
    required this.onPressed,
    double allSidesPadding = 12.0,
  }) : padding = EdgeInsets.all(allSidesPadding);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onPressed,
        child: Text(
          label,
          style: theme.textTheme.titleMedium,
        ),
      ),
    );
  }
}
