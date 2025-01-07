import 'package:flutter/material.dart';

import '/common/mixins/loading_overlay.dart';
import '/views/auth/register_form.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  static const routeName = '/register-screen';

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> with LoadingOverlay {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: RegisterForm(),
        ),
      ),
    );
  }
}
