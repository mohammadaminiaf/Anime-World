import 'package:anime_world/common/buttons/round_button.dart';
import 'package:anime_world/common/mixins/loading_overlay.dart';
import 'package:anime_world/common/styles/paddings.dart';
import 'package:anime_world/common/text_fields/email_text_field.dart';
import 'package:anime_world/common/text_fields/password_text_field.dart';
import 'package:anime_world/common/utils/validators.dart';
import 'package:anime_world/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          const SnackBar(content: Text('لطفا همه ورودی ها را پر کنید.')),
        );
        return;
      }

      ref.read(authProvider.notifier).login(
            username: email.split('@').first,
            password: password,
          );
    }
  }

  /// This method will redirect user to a website to sign in with his/her google account
  Future<void> _loginWithGoogle() async {
    // await AdapterAuth().loginWithGoogle(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = SizedBox(
      width: double.infinity,
      child: RoundButton(
        onPressed: () => _login(context),
        isLoading: false,
        label: 'ورود',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('ورود')),
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
                  hintText: 'ایمیل',
                  onVerify: () {
                    _showVerifyText.value = true;
                  },
                ),

                const SizedBox(height: 8),
                // Password
                PasswordTextField(
                  controller: _passwordController,
                  hintText: 'پسورد',
                  // validator: Validators.validatePassword,
                ),
                // Forget Password
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    // context.push(ScreenVerifyEmail.route);
                  },
                  child: const Text(
                    'رمز عبور خود را فراموش کرده اید؟',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
          const Text('حساب کاربری ندارید؟'),
          TextButton(
            onPressed: () => context.push(ScreenRegister.routeName),
            child: const Text('ثبت نام'),
          ),
        ],
      );
}
