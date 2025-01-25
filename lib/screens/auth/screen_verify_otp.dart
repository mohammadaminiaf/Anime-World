import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/buttons/round_button.dart';
import '/common/utils/utils.dart';
import '/notifiers/auth_notifier.dart';
import '/screens/auth/screen_reset_password.dart';
import '/widgets/auth/otp_input_field.dart';

class ScreenVerifyOtp extends ConsumerStatefulWidget {
  final String email;
  const ScreenVerifyOtp({super.key, required this.email});

  static const routeName = '/screen-verify-otp';

  @override
  ConsumerState<ScreenVerifyOtp> createState() => _ScreenVerifyOtpState();
}

class _ScreenVerifyOtpState extends ConsumerState<ScreenVerifyOtp> {
  String _otp = '';

  void _onOtpChanged(String otp) {
    setState(() => _otp = otp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                //! verify otp text
                _buildTitle(),
                const SizedBox(height: 16),
                _buildDescription(theme),
                const SizedBox(height: 40),

                //! OTP input fields
                OtpInputField(
                  otpLength: 6,
                  onChanged: _onOtpChanged,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Resend code logic
                      },
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Help center logic
                      },
                      child: Text(
                        'Help Center',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                //! Verify OTP Button
                _buildVerifyOtpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() => const Text(
        'Verify OTP',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildDescription(ThemeData theme) => Text(
        'We sent a 6-digit code to your email ${widget.email}.',
        style: TextStyle(
          fontSize: 16,
          color: theme.hintColor,
        ),
      );

  Widget _buildVerifyOtpButton() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(authProvider);

      ref.listen(
        authProvider,
        (pre, next) {
          //! If error
          if (pre is AsyncLoading && next is AsyncError) {
            Utils.showSnackBar(text: next.error.toString(), context: context);
          } else if (pre is AsyncLoading && next is AsyncData) {
            context.push(
              ScreenResetPassword.routeName,
              extra: {'email': widget.email, 'otp': _otp},
            );
          }
        },
      );

      return SizedBox(
        width: double.infinity,
        child: RoundButton(
          onPressed: () {
            ref.read(authProvider.notifier).verifyOTP(
                  email: widget.email,
                  otp: _otp,
                );
          },
          label: 'Continue',
          isLoading: state.isLoading,
        ),
      );
    });
  }
}
