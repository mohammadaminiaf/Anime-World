import 'package:anime_world/common/text_fields/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/buttons/round_button.dart';
import '/common/text_fields/round_text_field.dart';
import '/common/utils/utils.dart';
import '/notifiers/auth_notifier.dart';
import '/screens/auth/screen_login.dart';

class ScreenResetPassword extends ConsumerStatefulWidget {
  const ScreenResetPassword({
    super.key,
    required this.otp,
    required this.email,
  });

  final String otp;
  final String email;

  static const routeName = '/screen-reset-password';

  @override
  ConsumerState<ScreenResetPassword> createState() =>
      _ScreenUpdateProfileState();
}

class _ScreenUpdateProfileState extends ConsumerState<ScreenResetPassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  Future _resetPassword() async {
    final newPassword = _newPasswordController.text.trim();

    await ref.read(authProvider.notifier).resetPassword(
          email: widget.email,
          otp: widget.otp,
          newPassword: newPassword,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16, width: double.infinity),
              //! New password text field
              _buildNewPasswordField(),

              const SizedBox(height: 16),

              //! Password Reset Button
              _buildResetPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewPasswordField() => Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            PasswordTextField(
              controller: _newPasswordController,
              hintText: 'New Password',
            ),
            const SizedBox(height: 10),
          ],
        ),
      );

  Widget _buildResetPasswordButton() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authProvider);

        ref.listen(
          authProvider,
          (pre, next) {
            if (pre is AsyncLoading && next is AsyncData) {
              Utils.showSnackBar(
                  context: context, text: 'Password Reset Successfully!');
              context.go(ScreenLogin.routeName);
            } else if (pre is AsyncLoading && next is AsyncError) {
              // Login failed
              Utils.showSnackBar(context: context, text: '${next.error}');
            }
          },
        );

        return RoundButton(
          onPressed: _resetPassword,
          label: 'Reset Password',
          isLoading: state.isLoading,
          labelStyle: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}
