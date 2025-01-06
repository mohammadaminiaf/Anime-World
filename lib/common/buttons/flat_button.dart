import 'package:flutter/material.dart';

class FlatButton extends StatefulWidget {
  const FlatButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Colors.blueAccent,
    this.labelColor = Colors.white,
    this.isLoading = false,
    this.labelStyle,
    this.height = 50,
    this.isExpanded = false,
  });

  const FlatButton.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Colors.transparent,
    this.labelColor = Colors.black,
    this.isLoading = false,
    this.labelStyle,
    this.height = 50,
    this.isExpanded = false,
  });

  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color labelColor;
  final bool isLoading;
  final TextStyle? labelStyle;
  final double height;
  final bool isExpanded;

  @override
  State<FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: InkWell(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
          ),
          child: widget.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.5,
                  ),
                )
              : Center(
                  child: Text(
                    widget.label,
                    style: widget.labelStyle ??
                        TextStyle(
                          fontSize: 16.0,
                          color: widget.labelColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
        ),
      ),
    );
  }
}
