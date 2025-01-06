import 'package:anime_world/common/buttons/round_button.dart';
import 'package:flutter/material.dart';

mixin DialogMixin {
  /// Show a two-option dialog with custom text and callbacks.
  Future<bool?> showTwoOptionDialog({
    required BuildContext context,
    String title = 'تایید',
    String content = 'آیا مطمئن هستید که می‌خواهید ترک کنید؟',
    String yesButtonText = 'بله',
    String noButtonText = 'خیر',
    VoidCallback? onYesPressed,
    VoidCallback? onNoPressed,
  }) async {
    return showDialog<bool?>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: RoundButton(
                      height: 40,
                      onPressed: onYesPressed ??
                          () {
                            Navigator.of(context).pop(true); // Close dialog
                          },
                      backgroundColor: Colors.red,
                      label: yesButtonText,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: RoundButton(
                      height: 40,
                      onPressed: onNoPressed ??
                          () {
                            Navigator.of(context).pop(false); // Close dialog
                          },
                      backgroundColor: Colors.blue,
                      label: noButtonText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //! Display loading Dialog
  void displayLoadingDialog(BuildContext context, {String? text}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: LoadingDialog(text: text),
      ),
    );
  }

  //! Close loading Dialog
  void closeLoadingDialog(BuildContext context) => Navigator.pop(context);
}

class LoadingDialog extends StatelessWidget {
  final String? text;

  const LoadingDialog({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              text ?? 'در حال آپدیت',
              style: const TextStyle(
                color: Colors.white,
                letterSpacing: 2,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
