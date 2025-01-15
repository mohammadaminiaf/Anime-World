import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/buttons/round_button.dart';
import '/common/text_fields/round_text_field.dart';
import '/common/utils/utils.dart';
import '/notifiers/auth_notifier.dart';
import '/screens/screen_home.dart';

class ScreenChangePassword extends ConsumerStatefulWidget {
  const ScreenChangePassword({super.key});

  static const routeName = '/screen-change-password';

  @override
  ConsumerState<ScreenChangePassword> createState() =>
      _ScreenUpdateProfileState();
}

class _ScreenUpdateProfileState extends ConsumerState<ScreenChangePassword> {
  final _formKey = GlobalKey<FormState>();

  // Text Fields
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future _updateProfile() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    await ref.read(authProvider.notifier).changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
              _buildUpdateProfileForm(),
              const SizedBox(height: 16),
              Consumer(builder: (context, ref, child) {
                final user = ref.watch(authProvider);

                ref.listen(
                  authProvider,
                  (previous, next) {
                    if (next is AsyncData && next.value != null) {
                      // User successfully logged in
                      Utils.showSnackBar(
                        context: context,
                        text: 'Password changed Successfully!',
                      );

                      // Navigate to home screen
                      context.go(ScreenHome.routeName);
                    } else if (next is AsyncError) {
                      // Login failed
                      Utils.showSnackBar(
                        context: context,
                        text: 'Failed to change password: ${next.error}',
                      );
                    }
                  },
                );

                return RoundButton(
                  onPressed: _updateProfile,
                  label: 'Change Password',
                  isLoading: user.isLoading,
                  labelStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateProfileForm() => Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            RoundTextField(
              controller: _oldPasswordController,
              isPassword: true,
              hintText: 'Current Password',
            ),
            const SizedBox(height: 10),
            RoundTextField(
              controller: _newPasswordController,
              isPassword: true,
              hintText: 'New Password',
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
}
