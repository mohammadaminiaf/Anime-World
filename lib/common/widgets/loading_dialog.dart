import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent background
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        // Centered CircularProgressIndicator
        const Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }
}
