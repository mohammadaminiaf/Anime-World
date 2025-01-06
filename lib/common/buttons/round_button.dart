import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  const RoundButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Colors.lightGreenAccent,
    this.labelColor = Colors.white,
    this.isLoading = false,
    this.labelStyle,
    this.height = 50,
    this.isCompact = false,
    this.hasBorder = false,
  });

  const RoundButton.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Colors.transparent,
    this.labelColor = Colors.black,
    this.isLoading = false,
    this.labelStyle,
    this.height = 50,
    this.isCompact = false,
    this.hasBorder = true,
  });

  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color labelColor;
  final bool isLoading;
  final TextStyle? labelStyle;
  final double height;
  final bool isCompact;
  final bool? hasBorder;

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: InkWell(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: widget.isLoading ? 50 : widget.height,
          width: widget.isCompact
              ? 100
              : widget.isLoading
                  ? 50
                  : 500,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(
              widget.isLoading ? 50.0 : 15.0,
            ),
            border: widget.hasBorder!
                ? Border.all(
                    color: Colors.grey.shade500,
                    width: 2,
                  )
                : null,
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
