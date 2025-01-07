import 'package:anime_world/common/utils/utils.dart';
import 'package:anime_world/notifiers/auth_notifier.dart';
import 'package:anime_world/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/buttons/custom_text_button.dart';
import '/common/buttons/round_button.dart';
import '/common/mixins/loading_overlay.dart';
import '/common/styles/paddings.dart';
import '/common/text_fields/email_text_field.dart';
import '/common/text_fields/password_text_field.dart';
import 'screen_register.dart';

class ScreenLogin extends ConsumerStatefulWidget {
  const ScreenLogin({
    super.key,
    // required this.redirectedFrom,
  });

  // final String redirectedFrom;

  static const routeName = '/login-screen';

  @override
  ConsumerState<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends ConsumerState<ScreenLogin> with LoadingOverlay {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _showVerifyText = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (_loginFormKey.currentState?.validate() == true) {
      _loginFormKey.currentState?.save();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email and password are necessary.')),
        );
        return;
      }

      ref.read(authProvider.notifier).login(
            username: email.split('@').first,
            password: password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Consumer(
      builder: (context, ref, child) {
        final auth = ref.watch(authProvider);

        ref.listen(
          authProvider,
          (previous, next) {
            if (next is AsyncData && next.value != null) {
              // User successfully logged in
              Utils.showSnackBar(context: context, text: 'Login Successful!');

              // Navigate to home screen
              context.go(ScreenHome.routeName);
            } else if (next is AsyncError) {
              // Login failed
              Utils.showSnackBar(
                  context: context, text: 'Login failed: ${next.error}');
            }
          },
        );

        return SizedBox(
          width: double.infinity,
          child: RoundButton(
            backgroundColor: Colors.green,
            onPressed: () => _login(context),
            isLoading: auth.isLoading,
            label: 'Login',
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: Paddings.defaultPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email
                EmailTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  onVerify: () {
                    _showVerifyText.value = true;
                  },
                ),

                const SizedBox(height: 8),
                // Password
                PasswordTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  // validator: Validators.validatePassword,
                ),
                // Forget Password
                CustomTextButton.endPadding(
                  onPressed: () {
                    // context.push(ScreenVerifyEmail.route);
                  },
                  label: 'Forgot Password?',
                ),
                const SizedBox(height: 24),
                // Login Button
                loginButton,
                const SizedBox(height: 24),
                _buildDontHaveAccount(),
                const SizedBox(height: 24),
                // SocialLoginButton(
                //   iconUrl: 'assets/icons/google_logo.png',
                //   text: 'ورود با گوگل',
                //   onPressed: _loginWithGoogle,
                // ),
                // const SizedBox(height: 24),
                // SocialLoginButton(
                //   text: 'ورود با فیسبوک',
                //   iconUrl: 'assets/icons/facebook_logo.png',
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDontHaveAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Don\'t have an account?'),
          CustomTextButton.horizontalPadding(
            onPressed: () => context.push(ScreenRegister.routeName),
            label: 'Register',
          ),
        ],
      );
}
