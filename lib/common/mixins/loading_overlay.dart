import 'package:flutter/material.dart';

mixin LoadingOverlay {
  OverlayEntry? _overlayEntry;

  void showLoadingOverlay(BuildContext context) {
    if (_overlayEntry != null) return; // Prevent multiple overlays

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dimmed background
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Centered loading animation
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideLoadingOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
