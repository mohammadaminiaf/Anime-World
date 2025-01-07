import 'package:anime_world/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/common/buttons/round_button.dart';
import '/common/text_fields/password_text_field.dart';
import '/common/text_fields/round_text_field.dart';
import '/common/utils/utils.dart';
import '/common/utils/validators.dart';
import '/screens/auth/screen_login.dart';

final _formKey = GlobalKey<FormState>();

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final email = _emailController.text.trim();
      final name = _nameController.text.trim();
      final username = _usernameController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();
      final repeatPassword = _repeatPasswordController.text.trim();

      if (password != repeatPassword) {
        Utils.showSnackBar(
          text: 'Passwords do not match.',
          context: context,
        );
        return;
      }

      if (email.isNotEmpty &&
          name.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty) {
        ref.read(authProvider.notifier).register(
              name: name,
              username: username,
              email: email,
              phone: phone,
              password: password,
            );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  final spaceS = const SizedBox(height: 7);
  final spaceM = const SizedBox(height: 14);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundTextField(
            controller: _nameController,
            hintText: 'Full Name',
            validator: Validators.validateName,
          ),
          spaceS,
          RoundTextField(
            controller: _usernameController,
            hintText: 'Username',
            validator: Validators.validateName,
          ),
          spaceS,
          RoundTextField(
            controller: _emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          spaceS,
          RoundTextField(
            controller: _phoneController,
            hintText: 'Phone',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validatePhone,
          ),
          spaceS,
          PasswordTextField(
            controller: _passwordController,
            hintText: 'Password',
            validator: Validators.validatePassword,
          ),
          spaceS,
          PasswordTextField(
            controller: _repeatPasswordController,
            hintText: 'Confirm Password',
            validator: Validators.validatePassword,
          ),
          spaceM,
          Consumer(builder: (context, ref, child) {
            final auth = ref.watch(authProvider);
            ref.listen(
              authProvider,
              (previous, next) {
                if (next is AsyncData && next.value != null) {
                  // User successfully logged in
                  Utils.showSnackBar(
                    context: context,
                    text: 'Account Created successfully!',
                  );

                  // Navigate to home screen
                  context.go(ScreenLogin.routeName);
                } else if (next is AsyncError) {
                  // Login failed
                  Utils.showSnackBar(
                    context: context,
                    text: 'Failed to register: ${next.error}',
                  );
                }
              },
            );

            return RoundButton(
              onPressed: _register,
              label: 'Register',
              isLoading: auth.isLoading,
            );
          }),
          spaceM,
          _buildHaveAccount(),
        ],
      ),
    );
  }

  Widget _buildHaveAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Already have an account?'),
          TextButton(
            onPressed: () => context.push(ScreenLogin.routeName),
            child: const Text('Login'),
          ),
        ],
      );
}
