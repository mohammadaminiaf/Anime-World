import 'package:anime_world/screens/auth/screen_verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/buttons/custom_text_button.dart';
import '/common/buttons/round_button.dart';
import '/common/mixins/loading_overlay.dart';
import '/common/styles/paddings.dart';
import '/common/text_fields/email_text_field.dart';
import '/common/utils/utils.dart';
import '/notifiers/auth_notifier.dart';

class ScreenForgotPassword extends ConsumerStatefulWidget {
  const ScreenForgotPassword({super.key});

  static const routeName = '/screen-forgot-password';

  @override
  ConsumerState<ScreenForgotPassword> createState() =>
      _ScreenForgotPasswordState();
}

class _ScreenForgotPasswordState extends ConsumerState<ScreenForgotPassword>
    with LoadingOverlay {
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetPasswordEmail(BuildContext context) async {
    if (_forgotPasswordFormKey.currentState?.validate() == true) {
      _forgotPasswordFormKey.currentState?.save();
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        Utils.showSnackBar(context: context, text: 'Email is required.');
        return;
      }

      try {
        showLoadingOverlay(context);
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.sendOtp(email: email);

        // await authNotifier.sendPasswordResetEmail(email: email);
        Utils.showSnackBar(
          context: context,
          text: 'Password reset email sent successfully!',
        );
        context.push(ScreenVerifyOtp.routeName, extra: email);
      } catch (e) {
        Utils.showSnackBar(
          context: context,
          text: 'Failed to send password reset email: $e',
        );
      } finally {
        hideLoadingOverlay();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: Paddings.defaultPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _forgotPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Email Field
                EmailTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  onVerify: () {},
                ),
                const SizedBox(height: 24),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: RoundButton(
                    onPressed: () => _sendResetPasswordEmail(context),
                    label: 'Send Reset Email',
                  ),
                ),
                const SizedBox(height: 24),
                // Back to Login
                Center(
                  child: CustomTextButton.horizontalPadding(
                    onPressed: () => Navigator.pop(context),
                    label: 'Back to Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
