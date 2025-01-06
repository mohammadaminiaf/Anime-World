import 'package:anime_world/common/buttons/round_button.dart';
import 'package:anime_world/common/text_fields/password_text_field.dart';
import 'package:anime_world/common/text_fields/round_text_field.dart';
import 'package:anime_world/common/utils/utils.dart';
import 'package:anime_world/common/utils/validators.dart';
import 'package:anime_world/screens/auth/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _formKey = GlobalKey<FormState>();

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final email = _emailController.text.trim();
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final password = _passwordController.text.trim();
      final repeatPassword = _repeatPasswordController.text.trim();

      if (password != repeatPassword) {
        Utils.showSnackBar(
          text: 'رمزهای عبور مطابقت ندارند.',
          context: context,
        );
        return;
      }

      if (email.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          password.isNotEmpty) {
        // context.read<AuthBloc>().add(AuthEventRegister(
        //       email: email,
        //       firstName: firstName,
        //       lastName: lastName,
        //       password: password,
        //     ));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
            controller: _firstNameController,
            hintText: 'نام',
            validator: Validators.validateName,
          ),
          spaceS,
          RoundTextField(
            controller: _lastNameController,
            hintText: 'نام خانوادگی',
            validator: Validators.validateName,
          ),
          spaceS,
          RoundTextField(
            controller: _emailController,
            hintText: 'ایمیل',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          spaceS,
          PasswordTextField(
            controller: _passwordController,
            hintText: 'رمز عبور',
            validator: Validators.validatePassword,
          ),
          spaceS,
          PasswordTextField(
            controller: _repeatPasswordController,
            hintText: 'تکرار رمز عبور',
            validator: Validators.validatePassword,
          ),
          spaceM,
          RoundButton(
            onPressed: _register,
            label: 'ثبت نام',
            isLoading: false,
          ),
          spaceM,
          _buildHaveAccount(),
        ],
      ),
    );
  }

  Widget _buildHaveAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('قبلاً حساب کاربری دارید؟'),
          TextButton(
            onPressed: () => context.push(ScreenLogin.routeName),
            child: const Text('ورود'),
          ),
        ],
      );
}
