import 'package:flutter/material.dart';

class ViewAllHeader extends StatelessWidget {
  const ViewAllHeader({
    super.key,
    required this.title,
    required this.onViewAllClicked,
  });

  final String title;
  final VoidCallback onViewAllClicked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onViewAllClicked,
            child: const Text('View all'),
          ),
        ],
      ),
    );
  }
}
