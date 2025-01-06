import 'package:flutter/material.dart';

sealed class Paddings {
  static const defaultPadding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 16.0,
  );

  static const smallPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 10.0,
  );

  Paddings._();
}
